import 'package:http/http.dart' as http;

import '../../../core/net/net_error.dart';
import '../../../core/sync/sync_backend.dart';
import '../data/feed_repository.dart';
import '../parser/feed_parser.dart';
import 'nextcloud_news_client.dart';

// Sync driver for feeds. Two paths:
//   * Nextcloud News API — when the account exposes a NextcloudNewsClient
//     (an injected one constructed by the wiring layer at M11). Lists feeds
//     + items, mirrors read state.
//   * Direct fetch — for any FeedSubscriptions row whose feed URL doesn't
//     route through News API. Fetches the URL, parses with FeedParser,
//     upserts items.
//
// The repository is the offline-first store; this backend just orchestrates
// the network calls.

class FeedsSyncBackend extends SyncBackend {
  FeedsSyncBackend({
    required this.repository,
    this.newsClient,
    http.Client? httpClient,
    this.parser = const FeedParser(),
  }) : _http = httpClient ?? http.Client();

  final FeedRepository repository;
  final NextcloudNewsClient? newsClient;
  final FeedParser parser;
  final http.Client _http;

  @override
  String get kind => newsClient == null ? 'feeds-direct' : 'nextcloud-news';

  @override
  Future<SyncOutcome> pull({required int accountId}) async {
    var pulled = 0;
    try {
      if (newsClient != null) {
        pulled += await _pullViaNews();
      }
      pulled += await _pullViaDirect();
      return SyncOutcome(success: true, pulled: pulled);
    } on NetError catch (e) {
      return SyncOutcome(success: false, error: e);
    }
  }

  Future<int> _pullViaNews() async {
    final client = newsClient!;
    final remoteFeeds = await client.listFeeds();
    final remoteItems = await client.listItems();
    final existingByUrl = {
      for (final s in await repository.listSubscriptions()) s.url: s,
    };
    var inserted = 0;
    for (final remote in remoteFeeds) {
      var feedId = existingByUrl[remote.url]?.id;
      feedId ??= await repository.subscribe(
        url: remote.url,
        title: remote.title,
        folder: remote.folder,
      );
      final feedItems = remoteItems
          .where((i) => i.feedId == remote.id)
          .toList(growable: false);
      for (final item in feedItems) {
        final upsertedId = await repository.upsertItem(
          feedId: feedId,
          guid: item.guidHash,
          title: item.title,
          link: item.url,
          author: item.author,
          content: item.body,
          publishedAt: item.publishedAt,
        );
        if (!item.unread) {
          await repository.markRead(upsertedId);
        }
        inserted += 1;
      }
    }
    return inserted;
  }

  Future<int> _pullViaDirect() async {
    var inserted = 0;
    final subs = await repository.listSubscriptions();
    for (final sub in subs) {
      // Skip rows that already came from News API — by convention they live
      // in the same FeedSubscriptions table; the wiring layer flags them
      // by storing a "newsapi:" prefix on the URL when needed. For M10 we
      // attempt every URL that looks like a public HTTP(S) feed.
      if (!sub.url.startsWith('http')) {
        continue;
      }
      try {
        final response = await _http.get(Uri.parse(sub.url));
        if (response.statusCode < 200 || response.statusCode >= 300) {
          continue;
        }
        final parsed = parser.parse(response.body);
        for (final item in parsed.items) {
          await repository.upsertItem(
            feedId: sub.id,
            guid: item.guid,
            title: item.title,
            link: item.link,
            author: item.author,
            content: item.content,
            publishedAt: item.publishedAt,
          );
          inserted += 1;
        }
      } on FormatException {
        // Malformed feed — leave the existing items in place + retry later.
        continue;
      } on Exception {
        continue;
      }
    }
    return inserted;
  }

  @override
  Future<SyncOutcome> push({required int accountId}) async {
    // Feeds push only mirrors read state to the News API (if available).
    if (newsClient == null) {
      return const SyncOutcome(success: true);
    }
    // For M10 we don't yet diff read state — the read mirror is best-effort
    // when the user opens an item. M11 polish wires a pending-changes queue.
    return const SyncOutcome(success: true);
  }
}
