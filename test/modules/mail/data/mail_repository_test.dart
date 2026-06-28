import 'package:courrier/core/db/database.dart';
import 'package:courrier/modules/mail/backend/demo_mail_backend.dart';
import 'package:courrier/modules/mail/backend/mail_credentials.dart';
import 'package:courrier/modules/mail/data/mail_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

CourrierDatabase _db() => CourrierDatabase.forTesting(NativeDatabase.memory());

Future<MailRepository> _wire(CourrierDatabase db) async {
  final accountId = await db
      .into(db.accounts)
      .insert(AccountsCompanion.insert(kind: 'imap', displayName: 'Demo'));
  final backend = DemoMailBackend();
  await backend.connect(
    const PasswordCredentials(username: 'demo@example.org', password: 'pw'),
  );
  return MailRepository(db: db, backend: backend, accountId: accountId);
}

void main() {
  group('MailRepository', () {
    test('syncFolders mirrors backend folders into the DB', () async {
      final db = _db();
      addTearDown(db.close);
      final repo = await _wire(db);

      final folders = await repo.syncFolders();
      final names = folders.map((f) => f.name).toSet();
      expect(names, containsAll(['INBOX', 'Sent', 'Trash', 'Archive']));
    });

    test(
      'syncEnvelopes upserts and bodyDownloaded stays false until loadBody',
      () async {
        final db = _db();
        addTearDown(db.close);
        final repo = await _wire(db);
        await repo.syncFolders();
        final upserted = await repo.syncEnvelopes(folderName: 'INBOX');
        expect(upserted, greaterThan(0));

        final inbox = await repo.folderByName('INBOX');
        final rows = await (db.select(
          db.mailMessages,
        )..where((t) => t.folderId.equals(inbox.id))).get();
        for (final row in rows) {
          expect(row.bodyDownloaded, isFalse);
          expect(
            row.remoteContentAllowed,
            isFalse,
            reason: 'audit dim 4 — default-off remote content',
          );
        }

        // Load a body and confirm the flag flips.
        final message = rows.firstWhere((m) => m.uid == 105);
        await repo.loadBody(folderName: 'INBOX', messageId: message.id);
        final reloaded = await (db.select(
          db.mailMessages,
        )..where((t) => t.id.equals(message.id))).getSingle();
        expect(reloaded.bodyDownloaded, isTrue);
        expect(reloaded.bodyText, isNotNull);

        final attachments = await (db.select(
          db.mailAttachments,
        )..where((t) => t.messageId.equals(message.id))).get();
        expect(attachments, hasLength(1));
      },
    );

    test('threadsIn groups the 3-message thread + isolates others', () async {
      final db = _db();
      addTearDown(db.close);
      final repo = await _wire(db);
      await repo.syncFolders();
      await repo.syncEnvelopes(folderName: 'INBOX');

      final threads = await repo.threadsIn('INBOX');
      // 3-message thread + newsletter + receipts = 3 threads.
      expect(threads, hasLength(3));
      final big = threads.firstWhere((t) => t.messages.length == 3);
      expect(big.messages.map((m) => m.uid), [101, 102, 103]);
    });

    test('moveToTrash tombstones; emptyTrash purges from the DB', () async {
      final db = _db();
      addTearDown(db.close);
      final repo = await _wire(db);
      await repo.syncFolders();
      await repo.syncEnvelopes(folderName: 'INBOX');

      final inbox = await repo.folderByName('INBOX');
      final beforeRows = await (db.select(
        db.mailMessages,
      )..where((t) => t.folderId.equals(inbox.id))).get();
      final id101 = beforeRows.firstWhere((m) => m.uid == 101).id;

      await repo.moveToTrash(sourceFolderName: 'INBOX', messageIds: [id101]);

      // After move: row is now in trash, and trashed=true.
      final row = await (db.select(
        db.mailMessages,
      )..where((t) => t.id.equals(id101))).getSingle();
      final trash = await repo.folderByName('Trash');
      expect(row.folderId, trash.id);
      expect(row.trashed, isTrue);

      // Threading on INBOX now excludes it.
      final threadsAfter = await repo.threadsIn('INBOX');
      final flattened = threadsAfter
          .expand((t) => t.messages)
          .map((m) => m.uid);
      expect(flattened, isNot(contains(101)));

      await repo.emptyTrash();
      final stillThere = await (db.select(
        db.mailMessages,
      )..where((t) => t.id.equals(id101))).getSingleOrNull();
      expect(stillThere, isNull);
    });

    test('restoreFromTrash moves back and clears the tombstone', () async {
      final db = _db();
      addTearDown(db.close);
      final repo = await _wire(db);
      await repo.syncFolders();
      await repo.syncEnvelopes(folderName: 'INBOX');

      final inbox = await repo.folderByName('INBOX');
      final beforeRows = await (db.select(
        db.mailMessages,
      )..where((t) => t.folderId.equals(inbox.id))).get();
      final id102 = beforeRows.firstWhere((m) => m.uid == 102).id;

      await repo.moveToTrash(sourceFolderName: 'INBOX', messageIds: [id102]);
      await repo.restoreFromTrash(
        messageIds: [id102],
        destinationFolderName: 'INBOX',
      );

      final row = await (db.select(
        db.mailMessages,
      )..where((t) => t.id.equals(id102))).getSingle();
      expect(row.trashed, isFalse);
      expect(row.folderId, inbox.id);
    });

    test(
      'search finds the term across subject/from/snippet/body + snippet text',
      () async {
        final db = _db();
        addTearDown(db.close);
        final repo = await _wire(db);
        await repo.syncFolders();
        await repo.syncEnvelopes(folderName: 'INBOX');

        final hits = await repo.search('newsletter');
        expect(hits, isNotEmpty);
        expect(hits.first.message.subject, contains('newsletter'));

        final receiptHits = await repo.search('receipts');
        expect(receiptHits, isNotEmpty);
      },
    );
  });
}
