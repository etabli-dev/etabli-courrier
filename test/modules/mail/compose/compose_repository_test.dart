import 'package:courrier/core/db/database.dart';
import 'package:courrier/modules/mail/backend/demo_mail_backend.dart';
import 'package:courrier/modules/mail/backend/mail_credentials.dart';
import 'package:courrier/modules/mail/compose/compose_draft.dart';
import 'package:courrier/modules/mail/compose/compose_repository.dart';
import 'package:courrier/modules/mail/data/mail_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

CourrierDatabase _db() => CourrierDatabase.forTesting(NativeDatabase.memory());

Future<
  ({MailRepository mail, ComposeRepository compose, DemoMailBackend backend})
>
_wire(CourrierDatabase db) async {
  final accountId = await db
      .into(db.accounts)
      .insert(AccountsCompanion.insert(kind: 'imap', displayName: 'Demo'));
  final backend = DemoMailBackend();
  await backend.connect(
    const PasswordCredentials(username: 'me@example.org', password: 'pw'),
  );
  final mail = MailRepository(db: db, backend: backend, accountId: accountId);
  await mail.syncFolders();
  final compose = ComposeRepository(db: db, mailRepository: mail);
  return (mail: mail, compose: compose, backend: backend);
}

void main() {
  group('ComposeRepository', () {
    test(
      'saveDraft inserts a local row in Drafts AND appends to the backend',
      () async {
        final db = _db();
        addTearDown(db.close);
        final wired = await _wire(db);

        const draft = ComposeDraft(
          fromAddress: 'me@example.org',
          toAddresses: ['alice@example.org'],
          subject: 'WIP',
          bodyText: 'in progress',
        );
        final draftId = await wired.compose.saveDraft(draft);

        // Local mirror present?
        final stored = await (db.select(
          db.mailMessages,
        )..where((t) => t.id.equals(draftId))).getSingle();
        expect(stored.subject, 'WIP');
        expect(stored.fromAddress, 'me@example.org');
        expect(stored.toAddresses, contains('alice@example.org'));

        // Backend Drafts mirrors the append.
        final remote = await wired.backend.fetchEnvelopes(folderName: 'Drafts');
        expect(remote.any((e) => e.subject?.contains('WIP') ?? false), isTrue);
      },
    );

    test('sendNow sends + appends Sent + deletes the original draft', () async {
      final db = _db();
      addTearDown(db.close);
      final wired = await _wire(db);

      const draft = ComposeDraft(
        fromAddress: 'me@example.org',
        toAddresses: ['alice@example.org'],
        ccAddresses: ['bob@example.org'],
        subject: 'Final',
        bodyText: 'done',
      );
      final draftId = await wired.compose.saveDraft(draft);
      await wired.compose.sendNow(draft, draftMessageId: draftId);

      // Send recorded.
      expect(wired.backend.sentLog, hasLength(1));
      expect(
        wired.backend.sentLog.first.recipients,
        containsAll(['alice@example.org', 'bob@example.org']),
      );

      // Sent folder has the copy.
      final sent = await wired.backend.fetchEnvelopes(folderName: 'Sent');
      expect(sent.any((e) => e.subject?.contains('Final') ?? false), isTrue);

      // Draft row removed locally.
      final droppedDraft = await (db.select(
        db.mailMessages,
      )..where((t) => t.id.equals(draftId))).getSingleOrNull();
      expect(droppedDraft, isNull);
    });
  });
}
