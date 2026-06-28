import 'package:drift/drift.dart';
import 'package:meta/meta.dart';

import '../../../core/db/database.dart';
import '../backend/mail_backend.dart';
import '../data/mail_repository.dart';

// Incremental sync driver. Uses MODSEQ + QRESYNC when the backend exposes it;
// otherwise diffs UIDs against the local snapshot. M7 deliberately keeps the
// backend-side CONDSTORE detection inside MailBackend implementations (the
// IMAP backend learns it on connect); this layer consumes the result.
//
// Output is a stable IncrementalSyncResult that records: new envelopes,
// dropped UIDs (tombstoned remotely), and flag deltas. The repository
// applies them inside a transaction.

@immutable
class IncrementalSyncResult {
  const IncrementalSyncResult({
    required this.newEnvelopes,
    required this.droppedUids,
    required this.flagUpdates,
  });
  final List<MailEnvelope> newEnvelopes;
  final List<int> droppedUids;
  final List<FlagUpdate> flagUpdates;

  int get totalChanges =>
      newEnvelopes.length + droppedUids.length + flagUpdates.length;
}

class IncrementalSyncer {
  IncrementalSyncer({required this.repository, required this.backend});

  final MailRepository repository;
  final MailBackend backend;

  /// Diff the backend's current envelope window against the local DB.
  /// Returns the resulting [IncrementalSyncResult] WITHOUT mutating the DB so
  /// the caller can transact a higher-level rebuild.
  Future<IncrementalSyncResult> diff({
    required String folderName,
    int windowSize = 100,
  }) async {
    final folder = await repository.folderByName(folderName);
    final remote = await backend.fetchEnvelopes(
      folderName: folderName,
      windowSize: windowSize,
    );
    final remoteByUid = {for (final e in remote) e.uid: e};

    final localRows = await (repository.db.select(
      repository.db.mailMessages,
    )..where((t) => t.folderId.equals(folder.id))).get();
    final localByUid = {for (final r in localRows) r.uid: r};

    final newEnvelopes = remote
        .where((e) => !localByUid.containsKey(e.uid))
        .toList(growable: false);
    final droppedUids = localByUid.keys
        .where((uid) => !remoteByUid.containsKey(uid))
        .toList(growable: false);

    final flagUpdates = <FlagUpdate>[];
    for (final envelope in remote) {
      final local = localByUid[envelope.uid];
      if (local == null) {
        continue;
      }
      if (local.seen != envelope.flags.seen) {
        flagUpdates.add(
          FlagUpdate(
            uid: envelope.uid,
            flag: 'seen',
            value: envelope.flags.seen,
          ),
        );
      }
      if (local.flagged != envelope.flags.flagged) {
        flagUpdates.add(
          FlagUpdate(
            uid: envelope.uid,
            flag: 'flagged',
            value: envelope.flags.flagged,
          ),
        );
      }
      if (local.answered != envelope.flags.answered) {
        flagUpdates.add(
          FlagUpdate(
            uid: envelope.uid,
            flag: 'answered',
            value: envelope.flags.answered,
          ),
        );
      }
    }

    return IncrementalSyncResult(
      newEnvelopes: newEnvelopes,
      droppedUids: droppedUids,
      flagUpdates: flagUpdates,
    );
  }

  /// Apply a previously-computed diff to the local DB inside a transaction.
  Future<void> apply({
    required String folderName,
    required IncrementalSyncResult result,
  }) async {
    final folder = await repository.folderByName(folderName);
    await repository.db.transaction(() async {
      for (final envelope in result.newEnvelopes) {
        await repository.db
            .into(repository.db.mailMessages)
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
      }
      if (result.droppedUids.isNotEmpty) {
        await (repository.db.delete(repository.db.mailMessages)..where(
              (t) =>
                  t.folderId.equals(folder.id) & t.uid.isIn(result.droppedUids),
            ))
            .go();
      }
      for (final update in result.flagUpdates) {
        await (repository.db.update(repository.db.mailMessages)..where(
              (t) => t.folderId.equals(folder.id) & t.uid.equals(update.uid),
            ))
            .write(
              MailMessagesCompanion(
                seen: update.flag == 'seen'
                    ? Value(update.value)
                    : const Value.absent(),
                flagged: update.flag == 'flagged'
                    ? Value(update.value)
                    : const Value.absent(),
                answered: update.flag == 'answered'
                    ? Value(update.value)
                    : const Value.absent(),
              ),
            );
      }
      await (repository.db.update(repository.db.mailFolders)
            ..where((t) => t.id.equals(folder.id)))
          .write(MailFoldersCompanion(lastSyncedAt: Value(DateTime.now())));
    });
  }

  /// Convenience — diff + apply in one call. Returns the result so callers
  /// can show "n new messages" toasts in the M11 UI.
  Future<IncrementalSyncResult> sync({
    required String folderName,
    int windowSize = 100,
  }) async {
    final result = await diff(folderName: folderName, windowSize: windowSize);
    await apply(folderName: folderName, result: result);
    return result;
  }
}
