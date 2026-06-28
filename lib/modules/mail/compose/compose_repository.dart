import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../data/mail_repository.dart';
import 'compose_draft.dart';
import 'mime_builder.dart';

// Top-level send + draft management. Wraps MailRepository for the local store
// and a MailBackend for the wire.

class ComposeRepository {
  ComposeRepository({
    required this.db,
    required this.mailRepository,
    MimeBuilder? builder,
  }) : _builder = builder ?? const MimeBuilder();

  final CourrierDatabase db;
  final MailRepository mailRepository;
  final MimeBuilder _builder;

  /// Build the MIME bytes, append to the backend's Drafts folder, and persist
  /// a local row in the Drafts mirror so the UI surfaces it offline.
  Future<int> saveDraft(ComposeDraft draft) async {
    final bytes = _builder.buildRfc822(draft);
    final draftsName = await _specialFolderName(r'\Drafts');
    await mailRepository.backend.appendMessage(
      folderName: draftsName,
      rawMimeBytes: bytes,
    );
    final folder = await mailRepository.folderByName(draftsName);
    final localUid = await _nextLocalUid(folder.id);
    return db
        .into(db.mailMessages)
        .insert(
          MailMessagesCompanion.insert(
            folderId: folder.id,
            uid: localUid,
            subject: Value(draft.subject),
            fromAddress: Value(draft.fromAddress),
            toAddresses: Value(draft.toAddresses.join(', ')),
            ccAddresses: Value(draft.ccAddresses.join(', ')),
            bccAddresses: Value(draft.bccAddresses.join(', ')),
            receivedAt: Value(DateTime.now()),
            snippet: Value(_snippetFor(draft)),
            bodyText: Value(draft.bodyText),
            bodyHtml: Value(draft.bodyHtml),
            bodyDownloaded: const Value(true),
            remoteContentAllowed: const Value(false),
            hasAttachments: Value(draft.attachments.isNotEmpty),
          ),
        );
  }

  /// Send the draft + append a sent copy + delete the local draft (if any).
  Future<void> sendNow(ComposeDraft draft, {int? draftMessageId}) async {
    final bytes = _builder.buildRfc822(draft);
    final recipients = [
      ...draft.toAddresses,
      ...draft.ccAddresses,
      ...draft.bccAddresses,
    ];
    await mailRepository.backend.sendMessage(
      rawMimeBytes: bytes,
      fromAddress: draft.fromAddress,
      recipients: recipients,
    );
    final sentName = await _specialFolderName(r'\Sent');
    await mailRepository.backend.appendMessage(
      folderName: sentName,
      rawMimeBytes: bytes,
    );
    final sentFolder = await mailRepository.folderByName(sentName);
    final localUid = await _nextLocalUid(sentFolder.id);
    await db
        .into(db.mailMessages)
        .insert(
          MailMessagesCompanion.insert(
            folderId: sentFolder.id,
            uid: localUid,
            subject: Value(draft.subject),
            fromAddress: Value(draft.fromAddress),
            toAddresses: Value(draft.toAddresses.join(', ')),
            sentAt: Value(DateTime.now()),
            receivedAt: Value(DateTime.now()),
            snippet: Value(_snippetFor(draft)),
            bodyText: Value(draft.bodyText),
            bodyHtml: Value(draft.bodyHtml),
            bodyDownloaded: const Value(true),
          ),
        );
    if (draftMessageId != null) {
      await (db.delete(
        db.mailMessages,
      )..where((t) => t.id.equals(draftMessageId))).go();
    }
  }

  // ---- Internals ---------------------------------------------------------

  String _snippetFor(ComposeDraft draft) {
    final source = draft.bodyText ?? draft.bodyHtml ?? '';
    if (source.length <= 120) {
      return source;
    }
    return '${source.substring(0, 120)}…';
  }

  Future<String> _specialFolderName(String specialUse) async {
    final folder =
        await (db.select(db.mailFolders)..where(
              (t) =>
                  t.accountId.equals(mailRepository.accountId) &
                  t.specialUse.equals(specialUse),
            ))
            .getSingleOrNull();
    if (folder == null) {
      throw StateError('No folder with specialUse=$specialUse found');
    }
    return folder.name;
  }

  /// Allocate a UID for a locally-only inserted message (drafts, sent
  /// copies). Negative ids would also work, but enough_mail UIDs are 32-bit
  /// unsigned, so we just pick (current max + 1).
  Future<int> _nextLocalUid(int folderId) async {
    final row =
        await (db.selectOnly(db.mailMessages)
              ..addColumns([db.mailMessages.uid.max()])
              ..where(db.mailMessages.folderId.equals(folderId)))
            .getSingle();
    return (row.read(db.mailMessages.uid.max()) ?? 0) + 1;
  }
}
