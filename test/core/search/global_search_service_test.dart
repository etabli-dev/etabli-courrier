import 'package:courrier/core/db/database.dart';
import 'package:courrier/core/search/global_search_service.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

CourrierDatabase _db() => CourrierDatabase.forTesting(NativeDatabase.memory());

void main() {
  test(
    'search fans out across calendar, notes, mail + ranks by date desc',
    () async {
      final db = _db();
      addTearDown(db.close);
      final accountId = await db
          .into(db.accounts)
          .insert(
            AccountsCompanion.insert(kind: 'nextcloud', displayName: 'demo'),
          );
      final calendarCollectionId = await db
          .into(db.collections)
          .insert(
            CollectionsCompanion.insert(
              accountId: accountId,
              kind: 'calendar',
              displayName: 'Personal',
            ),
          );
      final notesCollectionId = await db
          .into(db.collections)
          .insert(
            CollectionsCompanion.insert(
              accountId: accountId,
              kind: 'notes',
              displayName: 'Notes',
            ),
          );
      final mailFolderId = await db
          .into(db.mailFolders)
          .insert(
            MailFoldersCompanion.insert(
              accountId: accountId,
              name: 'INBOX',
              specialUse: const Value(r'\Inbox'),
            ),
          );

      // 1) Calendar event with the term in summary.
      await db
          .into(db.calendarEvents)
          .insert(
            CalendarEventsCompanion.insert(
              collectionId: calendarCollectionId,
              uid: 'evt-suite',
              summary: const Value('Suite-wide release timing'),
              dtstart: Value(DateTime.utc(2026, 6, 20, 9)),
              rawIcs: '',
            ),
          );
      // 2) Note with the term in content.
      await db
          .into(db.noteItems)
          .insert(
            NoteItemsCompanion.insert(
              collectionId: notesCollectionId,
              title: 'Plan',
              content: 'Suite cadence for release',
              modified: Value(DateTime.utc(2026, 6, 21)),
            ),
          );
      // 3) Mail message with the term in subject.
      await db
          .into(db.mailMessages)
          .insert(
            MailMessagesCompanion.insert(
              folderId: mailFolderId,
              uid: 101,
              subject: const Value('Suite-wide release timing'),
              fromAddress: const Value('alice@etabli.dev'),
              snippet: const Value('Proposing a coordinated cut.'),
              receivedAt: Value(DateTime.utc(2026, 6, 22, 10)),
            ),
          );

      final service = GlobalSearchService(db: db);
      final hits = await service.search('suite');
      expect(hits.length, 3);
      // Mail is newest → first.
      expect(hits.first.module, SearchModule.mail);
      expect(hits[1].module, SearchModule.notes);
      expect(hits.last.module, SearchModule.calendar);
    },
  );

  test('empty term short-circuits to empty', () async {
    final db = _db();
    addTearDown(db.close);
    final service = GlobalSearchService(db: db);
    expect(await service.search(''), isEmpty);
    expect(await service.search('   '), isEmpty);
  });
}
