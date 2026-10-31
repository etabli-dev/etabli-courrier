import 'package:courrier/core/db/database.dart';
import 'package:courrier/modules/mail/backend/demo_mail_backend.dart';
import 'package:courrier/modules/mail/backend/mail_credentials.dart';
import 'package:courrier/modules/mail/data/mail_repository.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
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
    test(
      'move, fetch and restore use destination UIDs and retain cached attachments',
      () async {
        final db = _db();
        addTearDown(db.close);
        final repo = await _wire(db);
        await repo.syncFolders();
        await repo.syncEnvelopes(folderName: 'INBOX');
        final folder = await repo.folderByName('INBOX');
        final message =
            await (db.select(db.mailMessages)..where(
                  (t) =>
                      t.folderId.equals(folder.id) &
                      t.hasAttachments.equals(true),
                ))
                .getSingle();
        await repo.moveToTrash(
          sourceFolderName: 'INBOX',
          messageIds: [message.id],
        );
        final moved = await (db.select(
          db.mailMessages,
        )..where((t) => t.id.equals(message.id))).getSingle();
        expect(moved.uid, isNot(message.uid));
        final remote = await repo.loadBody(
          folderName: 'Trash',
          messageId: message.id,
        );
        final cached = await repo.loadBody(
          folderName: 'Trash',
          messageId: message.id,
        );
        expect(remote.attachments, isNotEmpty);
        expect(
          cached.attachments.map((a) => a.filename),
          remote.attachments.map((a) => a.filename),
        );
        await repo.restoreFromTrash(
          messageIds: [message.id],
          destinationFolderName: 'INBOX',
        );
        final restored = await (db.select(
          db.mailMessages,
        )..where((t) => t.id.equals(message.id))).getSingle();
        expect(restored.uid, isNot(moved.uid));
        await repo.setSeen(
          folderName: 'INBOX',
          messageId: message.id,
          seen: true,
        );
        final envelopes = await repo.backend.fetchEnvelopes(
          folderName: 'INBOX',
        );
        expect(
          envelopes.singleWhere((e) => e.uid == restored.uid).flags.seen,
          isTrue,
        );
      },
    );

    test(
      'message access and search stay inside the selected account and folder',
      () async {
        final db = _db();
        addTearDown(db.close);
        final first = await _wire(db);
        final second = await _wire(db);
        for (final repo in [first, second]) {
          await repo.syncFolders();
          await repo.syncEnvelopes(folderName: 'INBOX');
        }
        final inbox = await second.folderByName('INBOX');
        final message = (await (db.select(
          db.mailMessages,
        )..where((t) => t.folderId.equals(inbox.id))).get()).first;
        await expectLater(
          first.loadBody(folderName: 'INBOX', messageId: message.id),
          throwsStateError,
        );
        await expectLater(
          first.setSeen(folderName: 'INBOX', messageId: message.id, seen: true),
          throwsStateError,
        );
        await expectLater(
          first.setRemoteContentAllowed(messageId: message.id, allowed: true),
          throwsStateError,
        );
        await expectLater(
          first.archive(sourceFolderName: 'INBOX', messageIds: [message.id]),
          throwsStateError,
        );
        final firstInbox = await first.folderByName('INBOX');
        final hits = await first.search('newsletter');
        expect(hits, isNotEmpty);
        expect(
          hits.every((hit) => hit.message.folderId == firstInbox.id),
          isTrue,
        );
        await expectLater(
          second.loadBody(folderName: 'Sent', messageId: message.id),
          throwsStateError,
        );
      },
    );

    test('attachment write failure leaves the body fetch retryable', () async {
      final db = _db();
      addTearDown(db.close);
      final repo = await _wire(db);
      await repo.syncFolders();
      await repo.syncEnvelopes(folderName: 'INBOX');
      final message = await (db.select(
        db.mailMessages,
      )..where((t) => t.hasAttachments.equals(true))).getSingle();
      await db.customStatement(
        "CREATE TRIGGER fail_attachment BEFORE INSERT ON mail_attachments BEGIN SELECT RAISE(ABORT, 'full'); END",
      );
      await expectLater(
        repo.loadBody(folderName: 'INBOX', messageId: message.id),
        throwsA(anything),
      );
      final after = await (db.select(
        db.mailMessages,
      )..where((t) => t.id.equals(message.id))).getSingle();
      expect(after.bodyDownloaded, isFalse);
      expect(after.bodyText, isNull);
      await db.customStatement('DROP TRIGGER fail_attachment');
      expect(
        (await repo.loadBody(
          folderName: 'INBOX',
          messageId: message.id,
        )).attachments,
        isNotEmpty,
      );
    });

    test(
      'cyclic References form one bounded thread without losing messages',
      () async {
        final db = _db();
        addTearDown(db.close);
        final repo = await _wire(db);
        await repo.syncFolders();
        final folder = await repo.folderByName('INBOX');
        for (var i = 0; i < 3; i++) {
          await db
              .into(db.mailMessages)
              .insert(
                MailMessagesCompanion.insert(
                  folderId: folder.id,
                  uid: i + 1,
                  messageIdHeader: Value('<$i>'),
                  inReplyTo: Value('<${(i + 1) % 3}>'),
                  subject: Value('Message $i'),
                ),
              );
        }
        final threads = await repo.threadsIn('INBOX');
        expect(threads, hasLength(1));
        expect(threads.single.messages.map((m) => m.uid).toSet(), {1, 2, 3});
      },
    );

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
