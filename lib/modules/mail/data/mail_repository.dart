import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../backend/mail_backend.dart';
import '../backend/mail_credentials.dart';

// Offline-first mail repository. Backed by drift; orchestrates a MailBackend.
//
// Conventions:
//   * Folders are mirrored from the backend into `MailFolders` rows.
//   * Envelopes land as MailMessages with `bodyDownloaded=false`. The body
//     is fetched lazily by `loadBody`.
//   * `remoteContentAllowed` defaults to false (audit dim 4); the user flips
//     it per-message via the renderer's "Show images" toggle.
//   * Soft-delete moves messages to the Trash folder (server-side via the
//     backend, locally via tombstone). Restore unsets the tombstone and moves
//     them back. `emptyTrash` is the only path that actually EXPUNGEs.

class MailRepository {
  MailRepository({
    required this.db,
    required this.backend,
    required this.accountId,
  });

  final CourrierDatabase db;
  final MailBackend backend;
  final int accountId;

  Future<void> connect(MailCredentials credentials) =>
      backend.connect(credentials);

  Future<void> disconnect() => backend.disconnect();

  // ---- Folder sync --------------------------------------------------------

  Future<List<MailFolder>> syncFolders() async {
    final remote = await backend.listFolders();
    for (final handle in remote) {
      final existing =
          await (db.select(db.mailFolders)..where(
                (t) =>
                    t.accountId.equals(accountId) & t.name.equals(handle.name),
              ))
              .getSingleOrNull();
      if (existing == null) {
        await db
            .into(db.mailFolders)
            .insert(
              MailFoldersCompanion.insert(
                accountId: accountId,
                name: handle.name,
                specialUse: Value(handle.specialUse),
                delimiter: Value(handle.delimiter),
              ),
            );
      } else if (existing.specialUse != handle.specialUse) {
        await (db.update(db.mailFolders)
              ..where((t) => t.id.equals(existing.id)))
            .write(MailFoldersCompanion(specialUse: Value(handle.specialUse)));
      }
    }
    return (db.select(
      db.mailFolders,
    )..where((t) => t.accountId.equals(accountId))).get();
  }

  Future<MailFolder> folderByName(String name) async {
    return (db.select(db.mailFolders)
          ..where((t) => t.accountId.equals(accountId) & t.name.equals(name)))
        .getSingle();
  }

  // ---- Envelope sync ------------------------------------------------------

  Future<int> syncEnvelopes({
    required String folderName,
    int windowSize = 100,
  }) async {
    final folder = await folderByName(folderName);
    final envelopes = await backend.fetchEnvelopes(
      folderName: folderName,
      windowSize: windowSize,
    );
    var upserted = 0;
    for (final envelope in envelopes) {
      final existing =
          await (db.select(db.mailMessages)..where(
                (t) =>
                    t.folderId.equals(folder.id) & t.uid.equals(envelope.uid),
              ))
              .getSingleOrNull();
      if (existing == null) {
        await db
            .into(db.mailMessages)
            .insert(
              MailMessagesCompanion.insert(
                folderId: folder.id,
                uid: envelope.uid,
                messageIdHeader: Value(envelope.messageIdHeader),
                inReplyTo: Value(envelope.inReplyTo),
                referencesHeader: Value(envelope.referencesHeader),
                subject: Value(envelope.subject),
                fromAddress: Value(envelope.fromAddress),
                toAddresses: Value(envelope.toAddresses),
                ccAddresses: Value(envelope.ccAddresses),
                bccAddresses: Value(envelope.bccAddresses),
                sentAt: Value(envelope.receivedAt),
                seen: Value(envelope.flags.seen),
                flagged: Value(envelope.flags.flagged),
                answered: Value(envelope.flags.answered),
                hasAttachments: Value(envelope.hasAttachments),
                snippet: Value(envelope.snippet),
                receivedAt: Value(envelope.receivedAt),
              ),
            );
        upserted += 1;
      } else {
        // Server flags can drift while we're offline — update them.
        await (db.update(
          db.mailMessages,
        )..where((t) => t.id.equals(existing.id))).write(
          MailMessagesCompanion(
            seen: Value(envelope.flags.seen),
            flagged: Value(envelope.flags.flagged),
            answered: Value(envelope.flags.answered),
          ),
        );
      }
    }
    return upserted;
  }

  // ---- Body fetch (lazy) ---------------------------------------------------

  Future<MailBodyPayload> loadBody({
    required String folderName,
    required int messageId,
  }) async {
    final message = await (db.select(
      db.mailMessages,
    )..where((t) => t.id.equals(messageId))).getSingle();
    if (message.bodyDownloaded) {
      return MailBodyPayload(
        textPart: message.bodyText,
        htmlPart: message.bodyHtml,
      );
    }
    final payload = await backend.fetchBody(
      folderName: folderName,
      uid: message.uid,
    );
    await (db.update(
      db.mailMessages,
    )..where((t) => t.id.equals(messageId))).write(
      MailMessagesCompanion(
        bodyText: Value(payload.textPart),
        bodyHtml: Value(payload.htmlPart),
        bodyDownloaded: const Value(true),
      ),
    );
    for (final attachment in payload.attachments) {
      await db
          .into(db.mailAttachments)
          .insert(
            MailAttachmentsCompanion.insert(
              messageId: messageId,
              filename: attachment.filename,
              mimeType: attachment.mimeType,
              sizeBytes: attachment.sizeBytes,
              contentId: Value(attachment.contentId),
            ),
          );
    }
    return payload;
  }

  // ---- Flag updates --------------------------------------------------------

  Future<void> setSeen({
    required String folderName,
    required int messageId,
    required bool seen,
  }) async {
    final message = await (db.select(
      db.mailMessages,
    )..where((t) => t.id.equals(messageId))).getSingle();
    await backend.applyFlags(
      folderName: folderName,
      updates: [FlagUpdate(uid: message.uid, flag: 'seen', value: seen)],
    );
    await (db.update(db.mailMessages)..where((t) => t.id.equals(messageId)))
        .write(MailMessagesCompanion(seen: Value(seen)));
  }

  Future<void> setRemoteContentAllowed({
    required int messageId,
    required bool allowed,
  }) async {
    await (db.update(db.mailMessages)..where((t) => t.id.equals(messageId)))
        .write(MailMessagesCompanion(remoteContentAllowed: Value(allowed)));
  }

  // ---- Soft-delete trash + archive + restore ------------------------------

  Future<void> moveToTrash({
    required String sourceFolderName,
    required List<int> messageIds,
  }) async {
    final trashFolderName = await _specialFolderName(r'\Trash');
    await _moveLocallyAndRemote(
      sourceFolderName: sourceFolderName,
      destinationFolderName: trashFolderName,
      messageIds: messageIds,
      tombstone: true,
    );
  }

  Future<void> archive({
    required String sourceFolderName,
    required List<int> messageIds,
  }) async {
    final archiveFolderName = await _specialFolderName(r'\Archive');
    await _moveLocallyAndRemote(
      sourceFolderName: sourceFolderName,
      destinationFolderName: archiveFolderName,
      messageIds: messageIds,
    );
  }

  Future<void> restoreFromTrash({
    required List<int> messageIds,
    required String destinationFolderName,
  }) async {
    final trashFolderName = await _specialFolderName(r'\Trash');
    await _moveLocallyAndRemote(
      sourceFolderName: trashFolderName,
      destinationFolderName: destinationFolderName,
      messageIds: messageIds,
      tombstone: false,
    );
  }

  Future<void> emptyTrash() async {
    final trashFolderName = await _specialFolderName(r'\Trash');
    final folder = await folderByName(trashFolderName);
    await backend.expungeTrash(trashFolderName: trashFolderName);
    await (db.delete(
      db.mailMessages,
    )..where((t) => t.folderId.equals(folder.id))).go();
  }

  // ---- Threading ----------------------------------------------------------

  /// Groups every message currently in [folderName] into threads keyed by
  /// the References+In-Reply-To chain, with a subject-fallback for cases
  /// where headers are missing. Each thread is returned in receivedAt-asc
  /// order; threads themselves are returned with the newest message first.
  Future<List<MailThread>> threadsIn(String folderName) async {
    final folder = await folderByName(folderName);
    final rows =
        await (db.select(db.mailMessages)
              ..where(
                (t) => t.folderId.equals(folder.id) & t.trashed.equals(false),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.receivedAt)]))
            .get();
    return _groupIntoThreads(rows);
  }

  /// Local-first search across snippet/subject/from/bodyText. Returns
  /// [SearchHit]s with a snippet-with-highlight string.
  Future<List<SearchHit>> search(String term) async {
    if (term.trim().isEmpty) {
      return const <SearchHit>[];
    }
    final lower = term.toLowerCase();
    final pattern = '%${term.toLowerCase().replaceAll(' ', '%')}%';
    final messages =
        await (db.select(db.mailMessages)
              ..where(
                (t) =>
                    t.subject.lower().like(pattern) |
                    t.fromAddress.lower().like(pattern) |
                    t.snippet.lower().like(pattern) |
                    t.bodyText.lower().like(pattern),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.receivedAt)])
              ..limit(50))
            .get();
    return messages
        .map((m) => SearchHit(message: m, snippet: _buildSnippet(m, lower)))
        .toList(growable: false);
  }

  // ---- Internals ----------------------------------------------------------

  Future<void> _moveLocallyAndRemote({
    required String sourceFolderName,
    required String destinationFolderName,
    required List<int> messageIds,
    bool? tombstone,
  }) async {
    final sourceFolder = await folderByName(sourceFolderName);
    final destinationFolder = await folderByName(destinationFolderName);
    final messages = await (db.select(
      db.mailMessages,
    )..where((t) => t.id.isIn(messageIds))).get();
    final uids = messages.map((m) => m.uid).toList(growable: false);
    await backend.moveMessages(
      sourceFolder: sourceFolderName,
      destinationFolder: destinationFolderName,
      uids: uids,
    );
    for (final message in messages) {
      await (db.update(
        db.mailMessages,
      )..where((t) => t.id.equals(message.id))).write(
        MailMessagesCompanion(
          folderId: Value(destinationFolder.id),
          trashed: tombstone == null
              ? Value(message.trashed)
              : Value(tombstone),
          trashedAt: tombstone == true
              ? Value(DateTime.now())
              : tombstone == false
              ? const Value(null)
              : Value(message.trashedAt),
        ),
      );
    }
    // Bump the source folder's lastSyncedAt — the move is a delta we know about.
    await (db.update(db.mailFolders)
          ..where((t) => t.id.equals(sourceFolder.id)))
        .write(MailFoldersCompanion(lastSyncedAt: Value(DateTime.now())));
  }

  Future<String> _specialFolderName(String specialUse) async {
    final folder =
        await (db.select(db.mailFolders)..where(
              (t) =>
                  t.accountId.equals(accountId) &
                  t.specialUse.equals(specialUse),
            ))
            .getSingleOrNull();
    if (folder == null) {
      throw StateError('No folder with specialUse=$specialUse found');
    }
    return folder.name;
  }

  List<MailThread> _groupIntoThreads(List<MailMessage> messages) {
    final byMessageId = <String, MailMessage>{};
    for (final message in messages) {
      if (message.messageIdHeader != null) {
        byMessageId[message.messageIdHeader!] = message;
      }
    }
    // Build parent-of chains via In-Reply-To / References.
    final parentOf = <int, int>{};
    for (final message in messages) {
      final parentRef = _parentReference(message);
      if (parentRef == null) {
        continue;
      }
      final parent = byMessageId[parentRef];
      if (parent != null && parent.id != message.id) {
        parentOf[message.id] = parent.id;
      }
    }
    // Union-find by walking each message up to its root.
    final rootOf = <int, int>{};
    int root(int id) {
      var cursor = id;
      while (parentOf.containsKey(cursor)) {
        cursor = parentOf[cursor]!;
      }
      rootOf[id] = cursor;
      return cursor;
    }

    // Subject fallback: collapse same-subject messages without headers into
    // a single thread by trimmed/normalised subject.
    final subjectGroups = <String, int>{};
    for (final message in messages) {
      if (parentOf.containsKey(message.id)) {
        continue;
      }
      final key = _normalisedSubject(message.subject);
      if (key.isEmpty) {
        continue;
      }
      if (subjectGroups.containsKey(key)) {
        parentOf[message.id] = subjectGroups[key]!;
      } else {
        subjectGroups[key] = message.id;
      }
    }

    final buckets = <int, List<MailMessage>>{};
    for (final message in messages) {
      final r = root(message.id);
      (buckets[r] ??= <MailMessage>[]).add(message);
    }

    final threads = buckets.entries.map((entry) {
      final sorted = entry.value
        ..sort((a, b) => a.receivedAt.compareTo(b.receivedAt));
      return MailThread(messages: List<MailMessage>.unmodifiable(sorted));
    }).toList()..sort((a, b) => b.lastReceivedAt.compareTo(a.lastReceivedAt));
    return threads;
  }

  String? _parentReference(MailMessage message) {
    final inReplyTo = message.inReplyTo;
    if (inReplyTo != null && inReplyTo.isNotEmpty) {
      return inReplyTo.split(RegExp(r'\s+')).first;
    }
    final references = message.referencesHeader;
    if (references == null || references.isEmpty) {
      return null;
    }
    final tokens = references.split(RegExp(r'\s+'));
    return tokens.isEmpty ? null : tokens.last;
  }

  String _normalisedSubject(String? subject) {
    if (subject == null) {
      return '';
    }
    return subject
        .replaceFirst(RegExp(r'^(?:re:|fwd:|fw:)\s*', caseSensitive: false), '')
        .trim()
        .toLowerCase();
  }

  String _buildSnippet(MailMessage message, String lowerTerm) {
    final source = message.bodyText ?? message.snippet ?? '';
    if (source.isEmpty) {
      return source;
    }
    final lower = source.toLowerCase();
    final index = lower.indexOf(lowerTerm);
    if (index < 0) {
      return source.length > 120 ? '${source.substring(0, 120)}…' : source;
    }
    final start = (index - 32).clamp(0, source.length);
    final end = (index + lowerTerm.length + 32).clamp(0, source.length);
    final slice = source.substring(start, end);
    return start > 0 ? '…$slice…' : '$slice…';
  }
}

class MailThread {
  const MailThread({required this.messages});
  final List<MailMessage> messages;

  MailMessage get latest => messages.last;
  MailMessage get firstMessage => messages.first;
  DateTime get lastReceivedAt => latest.receivedAt;
}

class SearchHit {
  const SearchHit({required this.message, required this.snippet});
  final MailMessage message;
  final String snippet;
}
