import 'dart:io';

import 'package:courrier/core/db/database.dart';
import 'package:courrier/core/net/dav/dav_client.dart';
import 'package:courrier/core/net/net_error.dart';
import 'package:courrier/core/sync/dav_record_pull.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

String report(List<String> names, {String token = 'token-1', int? status}) =>
    '''<d:multistatus xmlns:d="DAV:">${names.map((n) => '<d:response><d:href>/dav/$n</d:href>${status == null ? '<d:propstat><d:prop><d:getetag>"v1"</d:getetag></d:prop><d:status>HTTP/1.1 200 OK</d:status></d:propstat>' : '<d:status>HTTP/1.1 $status Status</d:status>'}</d:response>').join()}<d:sync-token>$token</d:sync-token></d:multistatus>''';
String event(String uid, String title) =>
    'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nBEGIN:VEVENT\r\nUID:$uid\r\nSUMMARY:$title\r\nDTSTART;TZID=Europe/Berlin:20260701T120000\r\nX-CUSTOM:preserved\r\nEND:VEVENT\r\nEND:VCALENDAR\r\n';

void main() {
  late CourrierDatabase db;
  late int account, collection;
  setUp(() async {
    db = CourrierDatabase.forTesting(NativeDatabase.memory());
    account = await db
        .into(db.accounts)
        .insert(
          AccountsCompanion.insert(kind: 'nextcloud', displayName: 'fixture'),
        );
    collection = await db
        .into(db.collections)
        .insert(
          CollectionsCompanion.insert(
            accountId: account,
            kind: 'calendar',
            displayName: 'fixture',
          ),
        );
  });
  tearDown(() => db.close());
  DavRecordPull pull(http.Response Function(http.Request) handle) =>
      DavRecordPull(
        db: db,
        client: DavClient(
          credentials: const DavCredentials(
            username: 'fixture',
            password: 'fixture',
          ),
          httpClient: MockClient((r) async => handle(r)),
        ),
        resolve: (_) => Uri.parse('https://example.org/dav/'),
      );

  test(
    'downloads, updates in place and deletes by href independent from UID',
    () async {
      var title = 'Original';
      var deleted = false;
      final backend = pull(
        (r) => r.method == 'REPORT'
            ? http.Response(
                report(['opaque-file.ics'], status: deleted ? 404 : null),
                207,
              )
            : http.Response(
                event('uid-unrelated-to-filename', title),
                200,
                headers: {
                  'etag': '"etag"',
                  'content-type': 'text/calendar; charset=utf-8',
                },
              ),
      );
      expect((await backend.pull(account, 'calendar')).success, isTrue);
      final original = await db.select(db.calendarEvents).getSingle();
      expect(original.remoteHref, 'https://example.org/dav/opaque-file.ics');
      expect(original.rawIcs, contains('X-CUSTOM:preserved'));
      expect(original.dtstart!.toUtc(), DateTime.utc(2026, 7, 1, 10));
      title = 'Updated';
      expect((await backend.pull(account, 'calendar')).success, isTrue);
      final updated = await db.select(db.calendarEvents).getSingle();
      expect(updated.id, original.id);
      expect(updated.summary, 'Updated');
      deleted = true;
      expect((await backend.pull(account, 'calendar')).success, isTrue);
      expect(await db.select(db.calendarEvents).get(), isEmpty);
    },
  );

  test('partial download failure leaves records and token unchanged', () async {
    await (db.update(db.collections)..where((t) => t.id.equals(collection)))
        .write(const CollectionsCompanion(syncToken: Value('previous')));
    final backend = pull(
      (r) => r.method == 'REPORT'
          ? http.Response(report(['good.ics', 'bad.ics']), 207)
          : r.url.path.endsWith('bad.ics')
          ? http.Response('unavailable', 503)
          : http.Response(event('good', 'Good'), 200),
    );
    expect((await backend.pull(account, 'calendar')).success, isFalse);
    expect(await db.select(db.calendarEvents).get(), isEmpty);
    expect((await db.select(db.collections).getSingle()).syncToken, 'previous');
  });

  test(
    'forbidden response is a failure, never a deletion or token advance',
    () async {
      final backend = pull(
        (r) => http.Response(report(['private.ics'], status: 403), 207),
      );
      final result = await backend.pull(account, 'calendar');
      expect(result.error, isA<ForbiddenError>());
      expect((await db.select(db.collections).getSingle()).syncToken, isNull);
    },
  );

  test('pending local changes prevent pull from replacing them', () async {
    await db
        .into(db.pendingChanges)
        .insert(
          PendingChangesCompanion.insert(
            accountId: account,
            entityTable: 'calendar_events',
            entityId: 1,
            operation: 'update',
          ),
        );
    final backend = pull((r) => throw StateError('network must not run'));
    expect(
      (await backend.pull(account, 'calendar')).error,
      isA<ConflictError>(),
    );
    expect(await db.select(db.pendingChanges).get(), hasLength(1));
  });

  test('contacts and tasks retain source and populate display fields', () async {
    await db
        .into(db.collections)
        .insert(
          CollectionsCompanion.insert(
            accountId: account,
            kind: 'contacts',
            displayName: 'contacts',
          ),
        );
    await db
        .into(db.collections)
        .insert(
          CollectionsCompanion.insert(
            accountId: account,
            kind: 'tasks',
            displayName: 'tasks',
          ),
        );
    var source =
        'BEGIN:VCARD\nVERSION:4.0\nUID:contact\nFN:Person\nEMAIL:person@example.org\nEND:VCARD\n';
    final backend = pull(
      (r) => http.Response(
        r.method == 'REPORT' ? report(['object']) : source,
        r.method == 'REPORT' ? 207 : 200,
      ),
    );
    expect((await backend.pull(account, 'contacts')).success, isTrue);
    expect(
      (await db.select(db.contactCards).getSingle()).primaryEmail,
      'person@example.org',
    );
    source =
        'BEGIN:VCALENDAR\nBEGIN:VTODO\nUID:todo\nSUMMARY:Task\nDUE:20261031T120000Z\nEND:VTODO\nEND:VCALENDAR\n';
    expect((await backend.pull(account, 'tasks')).success, isTrue);
    expect(
      (await db.select(db.todoItems).getSingle()).due!.toUtc(),
      DateTime.utc(2026, 10, 31, 12),
    );
  });

  test(
    'v1 database upgrade preserves data and resets unusable old DAV tokens',
    () async {
      final dir = await Directory.systemTemp.createTemp('courrier-upgrade');
      final file = File('${dir.path}/history.sqlite');
      var persistent = CourrierDatabase.forTesting(NativeDatabase(file));
      try {
        final a = await persistent
            .into(persistent.accounts)
            .insert(
              AccountsCompanion.insert(
                kind: 'nextcloud',
                displayName: 'preserved',
              ),
            );
        final c = await persistent
            .into(persistent.collections)
            .insert(
              CollectionsCompanion.insert(
                accountId: a,
                kind: 'calendar',
                displayName: 'preserved',
                syncToken: const Value('old-token'),
              ),
            );
        await persistent
            .into(persistent.calendarEvents)
            .insert(
              CalendarEventsCompanion.insert(
                collectionId: c,
                uid: 'history',
                rawIcs: event('history', 'Preserved'),
              ),
            );
        for (final table in [
          'calendar_events',
          'contact_cards',
          'todo_items',
        ]) {
          await persistent.customStatement(
            'ALTER TABLE $table DROP COLUMN remote_href',
          );
        }
        await persistent.customStatement('PRAGMA user_version = 1');
        await persistent.close();
        persistent = CourrierDatabase.forTesting(NativeDatabase(file));
        expect(
          (await persistent.select(persistent.calendarEvents).getSingle()).uid,
          'history',
        );
        expect(
          (await persistent.select(persistent.calendarEvents).getSingle())
              .remoteHref,
          isNull,
        );
        expect(
          (await persistent.select(persistent.collections).getSingle())
              .syncToken,
          isNull,
        );
        expect(
          (await persistent.select(persistent.accounts).getSingle())
              .displayName,
          'preserved',
        );
      } finally {
        await persistent.close();
        await dir.delete(recursive: true);
      }
    },
  );
}
