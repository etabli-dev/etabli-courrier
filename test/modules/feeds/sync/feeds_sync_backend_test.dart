import 'dart:io';

import 'package:courrier/core/db/database.dart';
import 'package:courrier/modules/feeds/data/feed_repository.dart';
import 'package:courrier/modules/feeds/sync/feeds_sync_backend.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

CourrierDatabase _db() => CourrierDatabase.forTesting(NativeDatabase.memory());

Future<FeedRepository> _wire(CourrierDatabase db) async {
  final accountId = await db
      .into(db.accounts)
      .insert(
        AccountsCompanion.insert(kind: 'feeds-direct', displayName: 'demo'),
      );
  return FeedRepository(db: db, accountId: accountId);
}

String _load(String name) =>
    File('test/fixtures/feeds/$name').readAsStringSync();

void main() {
  group('FeedsSyncBackend — direct path', () {
    test('Fetches each subscription URL, parses, upserts items', () async {
      final db = _db();
      addTearDown(db.close);
      final repo = await _wire(db);
      await repo.subscribe(
        url: 'https://example.org/rss',
        title: 'Example RSS',
      );
      await repo.subscribe(
        url: 'https://example.org/atom',
        title: 'Example Atom',
      );

      final mock = MockClient((http.Request request) async {
        if (request.url.path.endsWith('/atom')) {
          return http.Response(_load('sample_atom.xml'), 200);
        }
        return http.Response(_load('sample_rss.xml'), 200);
      });

      final backend = FeedsSyncBackend(repository: repo, httpClient: mock);

      final outcome = await backend.pull(accountId: 0);
      expect(outcome.success, isTrue);

      final subs = await repo.listSubscriptions();
      for (final sub in subs) {
        final items = await repo.listItemsForFeed(sub.id);
        expect(items, hasLength(2));
      }
    });

    test(
      'Malformed feed body is swallowed; other subs still process',
      () async {
        final db = _db();
        addTearDown(db.close);
        final repo = await _wire(db);
        await repo.subscribe(
          url: 'https://example.org/broken',
          title: 'Broken',
        );
        await repo.subscribe(url: 'https://example.org/rss', title: 'Good');

        final mock = MockClient((http.Request request) async {
          if (request.url.path.endsWith('/broken')) {
            return http.Response('this is not xml', 200);
          }
          return http.Response(_load('sample_rss.xml'), 200);
        });

        final backend = FeedsSyncBackend(repository: repo, httpClient: mock);

        final outcome = await backend.pull(accountId: 0);
        expect(outcome.success, isTrue);

        final subs = await repo.listSubscriptions();
        final brokenItems = await repo.listItemsForFeed(
          subs.firstWhere((s) => s.title == 'Broken').id,
        );
        final goodItems = await repo.listItemsForFeed(
          subs.firstWhere((s) => s.title == 'Good').id,
        );
        expect(brokenItems, isEmpty);
        expect(goodItems, hasLength(2));
      },
    );
  });
}
