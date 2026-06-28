import 'package:courrier/core/config/runtime_config.dart';
import 'package:courrier/core/db/database.dart';
import 'package:courrier/core/net/dav/dav_client.dart';
import 'package:courrier/core/net/dav/discovery.dart';
import 'package:courrier/core/sync/connection_manager.dart';
import 'package:courrier/modules/calendar/data/calendar_repository.dart';
import 'package:courrier/modules/calendar/data/event_draft.dart';
import 'package:courrier/modules/calendar/sync/calendar_sync_backend.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

// Live Nextcloud round-trip — the M3 GATE: create → sync → reload.
//
// OPT-IN. Skipped if `NEXTCLOUD_BASE_URL` is empty in `secrets.json`.
// To run: `flutter test --dart-define-from-file=secrets.json
//          test/integration/live_nextcloud_calendar_test.dart`
//
// What it does:
//   1. Discover the user's calendar-home-set via .well-known/caldav.
//   2. Pick (or create on the server side beforehand) the first writeable
//      calendar collection.
//   3. Create a one-off VEVENT through the repo, push via the calendar sync
//      backend, then pull again and assert we read the same event back with
//      a server etag.

void main() {
  final hasCredentials = RuntimeConfig.hasNextcloudCredentials;

  group(
    'Live Nextcloud calendar round-trip',
    skip: hasCredentials
        ? null
        : 'secrets.json missing NEXTCLOUD_* — set to opt-in to live test',
    () {
      late CourrierDatabase db;
      late DavClient davClient;
      late Uri baseUrl;

      setUp(() async {
        db = CourrierDatabase.forTesting(NativeDatabase.memory());
        baseUrl = Uri.parse(RuntimeConfig.nextcloudBaseUrl);
        davClient = DavClient(
          credentials: const DavCredentials(
            username: RuntimeConfig.nextcloudUser,
            password: RuntimeConfig.nextcloudAppPassword,
          ),
        );
      });

      tearDown(() async {
        await db.close();
        await davClient.close();
      });

      test('create→sync→reload round-trip on a live calendar', () async {
        // 1. Discover.
        final discovery = DavDiscovery(client: davClient, baseUrl: baseUrl);
        final discoveryResult = await discovery.discover();
        expect(
          discoveryResult.calendarCollections,
          isNotEmpty,
          reason: 'no calendars on the test Nextcloud — create one first',
        );
        final calendar = discoveryResult.calendarCollections.first;

        // 2. Seed an account + a Collections row matching the discovered URL.
        final accountId = await db
            .into(db.accounts)
            .insert(
              AccountsCompanion.insert(
                kind: 'nextcloud',
                displayName: 'Live test',
                baseUrl: Value(baseUrl.toString()),
                username: const Value(RuntimeConfig.nextcloudUser),
              ),
            );
        final collectionId = await db
            .into(db.collections)
            .insert(
              CollectionsCompanion.insert(
                accountId: accountId,
                kind: 'calendar',
                displayName: calendar.displayName ?? 'Calendar',
                remoteHref: Value(calendar.href),
                ctag: Value(calendar.ctag),
                syncToken: Value(calendar.syncToken),
              ),
            );

        // 3. Wire repo + backend.
        final repo = CalendarRepository(
          db: db,
          uidGenerator: () =>
              'courrier-m3-${DateTime.now().millisecondsSinceEpoch}@etabli.dev',
        );
        final backend = CalendarSyncBackend(
          db: db,
          davClient: davClient,
          collectionUrlResolver: (Collection c) {
            final href = c.remoteHref;
            if (href == null) {
              throw StateError('Collection ${c.id} missing remoteHref');
            }
            return baseUrl.resolve(href);
          },
        );
        // ConnectionManager is just to mirror normal wiring; not exercised here.
        // ignore: unused_local_variable
        final connection = ConnectionManager();

        // 4. Create + push.
        final eventId = await repo.createEvent(
          EventDraft(
            collectionId: collectionId,
            summary: 'courrier M3 live test',
            start: DateTime.utc(2030, 1, 1, 10),
            end: DateTime.utc(2030, 1, 1, 11),
          ),
        );

        final pushOutcome = await backend.push(accountId: accountId);
        expect(pushOutcome.success, isTrue, reason: 'push failed');

        // 5. Pull and confirm a server etag landed on the row.
        final pullOutcome = await backend.pull(accountId: accountId);
        expect(pullOutcome.success, isTrue, reason: 'pull failed');

        final stored = await (db.select(
          db.calendarEvents,
        )..where((t) => t.id.equals(eventId))).getSingle();
        expect(
          stored.etag,
          isNotNull,
          reason: 'server etag should be present after push',
        );

        // Cleanup — delete on the server.
        await repo.deleteEvent(eventId);
        await backend.push(accountId: accountId);
      });
    },
  );
}
