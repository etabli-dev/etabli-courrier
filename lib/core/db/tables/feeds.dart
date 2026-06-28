import 'package:drift/drift.dart';

import 'accounts.dart';

class FeedSubscriptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();

  TextColumn get url => text()();
  TextColumn get title => text()();
  TextColumn get folder => text().nullable()();
  IntColumn get refreshIntervalMinutes =>
      integer().withDefault(const Constant(60))();
  DateTimeColumn get lastFetched => dateTime().nullable()();
}

class FeedItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get feedId => integer().references(
    FeedSubscriptions,
    #id,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get guid => text()();
  TextColumn get title => text()();
  TextColumn get link => text().nullable()();
  TextColumn get author => text().nullable()();
  TextColumn get content => text().nullable()();
  DateTimeColumn get publishedAt => dateTime().nullable()();
  BoolColumn get read => boolean().withDefault(const Constant(false))();
  BoolColumn get starred => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {feedId, guid},
  ];
}
