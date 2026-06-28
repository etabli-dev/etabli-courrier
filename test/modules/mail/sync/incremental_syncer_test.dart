import 'package:courrier/core/db/database.dart';
import 'package:courrier/modules/mail/backend/demo_mail_backend.dart';
import 'package:courrier/modules/mail/backend/mail_backend.dart';
import 'package:courrier/modules/mail/backend/mail_credentials.dart';
import 'package:courrier/modules/mail/data/mail_repository.dart';
import 'package:courrier/modules/mail/sync/incremental_syncer.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

CourrierDatabase _db() => CourrierDatabase.forTesting(NativeDatabase.memory());

Future<
  ({MailRepository repo, IncrementalSyncer syncer, DemoMailBackend backend})
>
_wire(CourrierDatabase db) async {
  final accountId = await db
      .into(db.accounts)
      .insert(AccountsCompanion.insert(kind: 'imap', displayName: 'Demo'));
  final backend = DemoMailBackend();
  await backend.connect(
    const PasswordCredentials(username: 'me@example.org', password: 'pw'),
  );
  final repo = MailRepository(db: db, backend: backend, accountId: accountId);
  await repo.syncFolders();
  await repo.syncEnvelopes(folderName: 'INBOX');
  final syncer = IncrementalSyncer(repository: repo, backend: backend);
  return (repo: repo, syncer: syncer, backend: backend);
}

void main() {
  group('IncrementalSyncer.diff', () {
    test('no remote change → empty result', () async {
      final db = _db();
      addTearDown(db.close);
      final wired = await _wire(db);
      final result = await wired.syncer.diff(folderName: 'INBOX');
      expect(result.newEnvelopes, isEmpty);
      expect(result.droppedUids, isEmpty);
      expect(result.flagUpdates, isEmpty);
      expect(result.totalChanges, 0);
    });

    test('remote flag flip → flag update', () async {
      final db = _db();
      addTearDown(db.close);
      final wired = await _wire(db);

      await wired.backend.applyFlags(
        folderName: 'INBOX',
        updates: const [FlagUpdate(uid: 101, flag: 'seen', value: true)],
      );
      final result = await wired.syncer.diff(folderName: 'INBOX');
      expect(result.flagUpdates, hasLength(1));
      expect(result.flagUpdates.first.flag, 'seen');
      expect(result.flagUpdates.first.value, isTrue);
    });

    test('remote tombstone → droppedUids', () async {
      final db = _db();
      addTearDown(db.close);
      final wired = await _wire(db);

      await wired.backend.moveMessages(
        sourceFolder: 'INBOX',
        destinationFolder: 'Trash',
        uids: [101],
      );
      await wired.backend.expungeTrash(trashFolderName: 'Trash');

      final result = await wired.syncer.diff(folderName: 'INBOX');
      expect(result.droppedUids, contains(101));
    });
  });

  group('IncrementalSyncer.apply', () {
    test(
      'flag updates are written, drops remove rows, new inserts land',
      () async {
        final db = _db();
        addTearDown(db.close);
        final wired = await _wire(db);

        await wired.backend.applyFlags(
          folderName: 'INBOX',
          updates: const [FlagUpdate(uid: 101, flag: 'seen', value: true)],
        );
        await wired.backend.moveMessages(
          sourceFolder: 'INBOX',
          destinationFolder: 'Trash',
          uids: [105],
        );
        await wired.backend.expungeTrash(trashFolderName: 'Trash');

        final outcome = await wired.syncer.sync(folderName: 'INBOX');
        expect(outcome.flagUpdates, hasLength(1));
        expect(outcome.droppedUids, contains(105));

        final inbox = await wired.repo.folderByName('INBOX');
        final survivors = await (db.select(
          db.mailMessages,
        )..where((t) => t.folderId.equals(inbox.id))).get();
        final uids = survivors.map((m) => m.uid).toSet();
        expect(uids, isNot(contains(105)));
        final updated = survivors.firstWhere((m) => m.uid == 101);
        expect(updated.seen, isTrue);
      },
    );
  });
}
