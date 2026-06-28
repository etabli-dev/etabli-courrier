import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'tables/accounts.dart';
import 'tables/calendar.dart';
import 'tables/contacts.dart';
import 'tables/feeds.dart';
import 'tables/mail.dart';
import 'tables/notes.dart';
import 'tables/sync.dart';
import 'tables/tasks.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Accounts,
    Collections,
    CalendarEvents,
    EventReminders,
    EventRecurrenceOverrides,
    ContactCards,
    ContactGroups,
    ContactGroupMembers,
    TodoItems,
    NoteItems,
    FeedSubscriptions,
    FeedItems,
    MailFolders,
    MailMessages,
    MailAttachments,
    PendingChanges,
    SyncConflicts,
  ],
)
class CourrierDatabase extends _$CourrierDatabase {
  CourrierDatabase() : super(_openConnection());

  CourrierDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // No upgrades yet — schema_v1 is the M1 surface. Subsequent
      // milestones add migrations and a step is added here for each.
    },
    beforeOpen: (OpeningDetails details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'courrier.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
