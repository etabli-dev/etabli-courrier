import 'package:drift/drift.dart';

import '../../../core/db/database.dart';

// Offline-first feeds repository over the M1 schema's FeedSubscriptions +
// FeedItems. Sync hits Nextcloud News when available and the bundled
// FeedParser as the direct-feed fallback (see FeedsSyncBackend).

class FeedRepository {
  FeedRepository({required this.db, required this.accountId});

  final CourrierDatabase db;
  final int accountId;

  // ---- Subscriptions -----------------------------------------------------

  Future<int> subscribe({
    required String url,
    required String title,
    String? folder,
    int refreshIntervalMinutes = 60,
  }) => db
      .into(db.feedSubscriptions)
      .insert(
        FeedSubscriptionsCompanion.insert(
          accountId: accountId,
          url: url,
          title: title,
          folder: Value(folder),
          refreshIntervalMinutes: Value(refreshIntervalMinutes),
        ),
      );

  Future<void> unsubscribe(int feedId) async {
    await (db.delete(
      db.feedSubscriptions,
    )..where((t) => t.id.equals(feedId))).go();
  }

  Future<List<FeedSubscription>> listSubscriptions() {
    return (db.select(db.feedSubscriptions)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.asc(t.title)]))
        .get();
  }

  Stream<List<FeedSubscription>> watchSubscriptions() {
    return (db.select(db.feedSubscriptions)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.asc(t.title)]))
        .watch();
  }

  // ---- Items -------------------------------------------------------------

  Future<List<FeedItem>> listItemsForFeed(int feedId) {
    return (db.select(db.feedItems)
          ..where((t) => t.feedId.equals(feedId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.publishedAt),
            (t) => OrderingTerm.desc(t.id),
          ]))
        .get();
  }

  Future<List<FeedItem>> unreadAcrossSubscriptions({int limit = 200}) async {
    final subs = await listSubscriptions();
    if (subs.isEmpty) {
      return const <FeedItem>[];
    }
    final ids = subs.map((s) => s.id).toList(growable: false);
    return (db.select(db.feedItems)
          ..where((t) => t.feedId.isIn(ids) & t.read.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.publishedAt)])
          ..limit(limit))
        .get();
  }

  Future<int> upsertItem({
    required int feedId,
    required String guid,
    required String title,
    String? link,
    String? author,
    String? content,
    DateTime? publishedAt,
  }) async {
    final existing =
        await (db.select(db.feedItems)
              ..where((t) => t.feedId.equals(feedId) & t.guid.equals(guid)))
            .getSingleOrNull();
    if (existing == null) {
      return db
          .into(db.feedItems)
          .insert(
            FeedItemsCompanion.insert(
              feedId: feedId,
              guid: guid,
              title: title,
              link: Value(link),
              author: Value(author),
              content: Value(content),
              publishedAt: Value(publishedAt),
            ),
          );
    }
    await (db.update(
      db.feedItems,
    )..where((t) => t.id.equals(existing.id))).write(
      FeedItemsCompanion(
        title: Value(title),
        link: Value(link),
        author: Value(author),
        content: Value(content),
        publishedAt: Value(publishedAt),
      ),
    );
    return existing.id;
  }

  Future<void> markRead(int itemId, {bool read = true}) async {
    await (db.update(db.feedItems)..where((t) => t.id.equals(itemId))).write(
      FeedItemsCompanion(read: Value(read)),
    );
  }

  Future<void> markFeedRead(int feedId) async {
    await (db.update(db.feedItems)..where((t) => t.feedId.equals(feedId)))
        .write(const FeedItemsCompanion(read: Value(true)));
  }

  Future<int> unreadCountFor(int feedId) async {
    final rows = await (db.select(
      db.feedItems,
    )..where((t) => t.feedId.equals(feedId) & t.read.equals(false))).get();
    return rows.length;
  }

  Future<void> updateRefreshInterval({
    required int feedId,
    required int minutes,
  }) async {
    await (db.update(
      db.feedSubscriptions,
    )..where((t) => t.id.equals(feedId))).write(
      FeedSubscriptionsCompanion(refreshIntervalMinutes: Value(minutes)),
    );
  }
}
