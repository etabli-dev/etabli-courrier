import 'package:courrier/core/db/database.dart';
import 'package:courrier/modules/feeds/data/feed_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

CourrierDatabase _db() => CourrierDatabase.forTesting(NativeDatabase.memory());

Future<FeedRepository> _wire(CourrierDatabase db) async {
  final accountId = await db
      .into(db.accounts)
      .insert(AccountsCompanion.insert(kind: 'nextcloud', displayName: 'demo'));
  return FeedRepository(db: db, accountId: accountId);
}

void main() {
  group('FeedRepository CRUD', () {
    test('subscribe + listSubscriptions + unsubscribe', () async {
      final db = _db();
      addTearDown(db.close);
      final repo = await _wire(db);

      final id = await repo.subscribe(
        url: 'https://example.org/rss',
        title: 'Example',
        folder: 'Tech',
      );
      var subs = await repo.listSubscriptions();
      expect(subs, hasLength(1));
      expect(subs.first.url, 'https://example.org/rss');
      expect(subs.first.folder, 'Tech');

      await repo.unsubscribe(id);
      subs = await repo.listSubscriptions();
      expect(subs, isEmpty);
    });

    test('upsertItem is idempotent on (feedId, guid)', () async {
      final db = _db();
      addTearDown(db.close);
      final repo = await _wire(db);

      final feedId = await repo.subscribe(
        url: 'https://example.org/rss',
        title: 'Example',
      );
      await repo.upsertItem(feedId: feedId, guid: 'g1', title: 'Original');
      await repo.upsertItem(feedId: feedId, guid: 'g1', title: 'Updated');
      final items = await repo.listItemsForFeed(feedId);
      expect(items, hasLength(1));
      expect(items.first.title, 'Updated');
    });

    test('markRead + unread count + markFeedRead', () async {
      final db = _db();
      addTearDown(db.close);
      final repo = await _wire(db);

      final feedId = await repo.subscribe(
        url: 'https://example.org/rss',
        title: 'Example',
      );
      final a = await repo.upsertItem(feedId: feedId, guid: 'a', title: 'A');
      final b = await repo.upsertItem(feedId: feedId, guid: 'b', title: 'B');
      expect(await repo.unreadCountFor(feedId), 2);

      await repo.markRead(a);
      expect(await repo.unreadCountFor(feedId), 1);
      expect(b, isNotNull);

      await repo.markFeedRead(feedId);
      expect(await repo.unreadCountFor(feedId), 0);
    });

    test('updateRefreshInterval persists', () async {
      final db = _db();
      addTearDown(db.close);
      final repo = await _wire(db);

      final feedId = await repo.subscribe(
        url: 'https://example.org/rss',
        title: 'Example',
      );
      await repo.updateRefreshInterval(feedId: feedId, minutes: 720);
      final subs = await repo.listSubscriptions();
      expect(subs.first.refreshIntervalMinutes, 720);
    });
  });
}
