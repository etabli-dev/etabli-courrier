import 'package:drift/drift.dart';

import '../db/database.dart';
import '../ical/ical_component.dart';
import '../ical/ical_reader.dart';
import '../net/bounded_http.dart';
import '../net/dav/dav_client.dart';
import '../net/dav/sync_collection.dart';
import '../net/net_error.dart';
import '../recurrence/ical_date.dart';
import 'sync_backend.dart';

/// A collection token is committed in the same transaction as its records.
/// Remote hrefs are independent from component UIDs and remain opaque.
class DavRecordPull {
  DavRecordPull({
    required this.db,
    required this.client,
    required this.resolve,
  });
  final CourrierDatabase db;
  final DavClient client;
  final Uri Function(Collection) resolve;

  Future<SyncOutcome> pull(int accountId, String kind) async {
    var pulled = 0;
    try {
      final collections =
          await (db.select(db.collections)..where(
                (t) =>
                    t.accountId.equals(accountId) &
                    t.kind.equals(kind) &
                    t.enabled.equals(true),
              ))
              .get();
      for (final collection in collections) {
        final table = switch (kind) {
          'calendar' => 'calendar_events',
          'contacts' => 'contact_cards',
          'tasks' => 'todo_items',
          _ => throw ArgumentError('Unsupported collection'),
        };
        final pending =
            await (db.select(db.pendingChanges)..where(
                  (t) =>
                      t.accountId.equals(accountId) &
                      t.entityTable.equals(table),
                ))
                .get();
        // Push first, or resolve conflicts, before replacing local edits.
        if (pending.isNotEmpty) throw const ConflictError();
        final url = resolve(collection);
        final result = await SyncCollectionClient(
          client,
        ).run(collectionUrl: url, syncToken: collection.syncToken);
        if (result.changedHrefs.length > 5000) {
          throw const ParseFailureError(
            'collection exceeds 5000 changes per pass',
          );
        }
        final records = <_Record>[];
        var bytes = 0;
        for (final href in result.changedHrefs.toSet()) {
          final target = sameOrigin(url, href);
          if (!target.path.startsWith(
            url.path.endsWith('/') ? url.path : '${url.path}/',
          )) {
            throw const ParseFailureError('resource is outside its collection');
          }
          final response = await client.get(url: target);
          bytes += response.bodyBytes.length;
          if (bytes > 64 * 1024 * 1024) {
            throw const ParseFailureError('collection exceeds 64 MiB per pass');
          }
          final raw = response.body;
          final root = const IcalReader().parse(raw);
          final componentName = switch (kind) {
            'calendar' => 'VEVENT',
            'tasks' => 'VTODO',
            _ => 'VCARD',
          };
          if ((kind == 'contacts' && root.name != 'VCARD') ||
              (kind != 'contacts' && root.name != 'VCALENDAR')) {
            throw const FormatException('Unexpected DAV record type');
          }
          final components = kind == 'contacts'
              ? [root]
              : root.childrenOf(componentName).toList();
          if (components.isEmpty) {
            continue; // Mixed VEVENT/VTODO calendars are valid.
          }
          final master =
              components
                  .where((c) => c.get('RECURRENCE-ID') == null)
                  .firstOrNull ??
              components.first;
          final uid = master.get('UID')?.value;
          if (uid == null ||
              uid.isEmpty ||
              components.any((c) => c.get('UID')?.value != uid)) {
            throw const FormatException(
              'Missing or inconsistent component UID',
            );
          }
          records.add(
            _Record(
              target.toString(),
              uid,
              response.headers['etag'],
              raw,
              master,
            ),
          );
        }
        await db.transaction(() async {
          // Recheck after network I/O in case a user edited the local record.
          if ((await (db.select(db.pendingChanges)..where(
                    (t) =>
                        t.accountId.equals(accountId) &
                        t.entityTable.equals(table),
                  ))
                  .get())
              .isNotEmpty) {
            throw const ConflictError();
          }
          final seen = <String>{};
          for (final record in records) {
            if (!seen.add(record.uid)) {
              throw const FormatException('Duplicate UID across DAV resources');
            }
            await _upsert(kind, collection.id, record);
          }
          final existing = await db
              .customSelect(
                'SELECT id, remote_href FROM $table WHERE collection_id = ? AND remote_href IS NOT NULL',
                variables: [Variable(collection.id)],
              )
              .get();
          final deleted = result.deletedHrefs
              .map((h) => sameOrigin(url, h).toString())
              .toSet();
          final retained = records.map((r) => r.href).toSet();
          final changed = result.changedHrefs
              .map((h) => sameOrigin(url, h).toString())
              .toSet();
          final full = collection.syncToken == null || result.tokenWasReset;
          for (final row in existing) {
            final href = row.read<String>('remote_href');
            if (deleted.contains(href) ||
                ((full || changed.contains(href)) &&
                    !retained.contains(href))) {
              await db.customUpdate(
                'DELETE FROM $table WHERE id = ?',
                variables: [Variable(row.read<int>('id'))],
                updates: {db.calendarEvents, db.contactCards, db.todoItems},
                updateKind: UpdateKind.delete,
              );
            }
          }
          await (db.update(
            db.collections,
          )..where((t) => t.id.equals(collection.id))).write(
            CollectionsCompanion(
              syncToken: Value(result.newSyncToken),
              lastSyncedAt: Value(DateTime.now()),
            ),
          );
        });
        pulled += records.length;
      }
      return SyncOutcome(success: true, pulled: pulled);
    } on NetError catch (error) {
      return SyncOutcome(success: false, pulled: pulled, error: error);
    } on FormatException catch (error) {
      return SyncOutcome(
        success: false,
        pulled: pulled,
        error: ParseFailureError('invalid remote record', cause: error),
      );
    }
  }

  DateTime? _date(IcalComponent c, String name) {
    final p = c.get(name);
    if (p == null) return null;
    return const IcalDateParser()
        .parse(
          p.value,
          valueParam: p.param('VALUE'),
          tzidParam: p.param('TZID'),
        )
        .toDateTime();
  }

  Future<void> _upsert(String kind, int collection, _Record r) async {
    final c = r.component;
    String? value(String key) => c.get(key)?.value;
    if (kind == 'calendar') {
      final row = CalendarEventsCompanion.insert(
        collectionId: collection,
        uid: r.uid,
        remoteHref: Value(r.href),
        etag: Value(r.etag),
        rawIcs: r.raw,
        summary: Value(value('SUMMARY')),
        description: Value(value('DESCRIPTION')),
        location: Value(value('LOCATION')),
        dtstart: Value(_date(c, 'DTSTART')),
        dtend: Value(_date(c, 'DTEND')),
        allDay: Value(
          c.get('DTSTART')?.param('VALUE') == 'DATE' ||
              value('DTSTART')?.length == 8,
        ),
        rrule: Value(value('RRULE')),
        organizer: Value(value('ORGANIZER')),
      );
      await db
          .into(db.calendarEvents)
          .insert(
            row,
            onConflict: DoUpdate(
              (_) => row,
              target: [db.calendarEvents.collectionId, db.calendarEvents.uid],
            ),
          );
    } else if (kind == 'tasks') {
      final row = TodoItemsCompanion.insert(
        collectionId: collection,
        uid: r.uid,
        remoteHref: Value(r.href),
        etag: Value(r.etag),
        rawIcs: r.raw,
        summary: Value(value('SUMMARY')),
        description: Value(value('DESCRIPTION')),
        due: Value(_date(c, 'DUE')),
        completed: Value(_date(c, 'COMPLETED')),
        percentComplete: Value(int.tryParse(value('PERCENT-COMPLETE') ?? '')),
        priority: Value(int.tryParse(value('PRIORITY') ?? '')),
        rrule: Value(value('RRULE')),
        parentUid: Value(
          c
              .getAll('RELATED-TO')
              .where(
                (p) =>
                    (p.param('RELTYPE') ?? 'PARENT').toUpperCase() == 'PARENT',
              )
              .firstOrNull
              ?.value,
        ),
      );
      await db
          .into(db.todoItems)
          .insert(
            row,
            onConflict: DoUpdate(
              (_) => row,
              target: [db.todoItems.collectionId, db.todoItems.uid],
            ),
          );
    } else {
      final names = (value('N') ?? '').split(';');
      final row = ContactCardsCompanion.insert(
        collectionId: collection,
        uid: r.uid,
        remoteHref: Value(r.href),
        etag: Value(r.etag),
        rawVcard: r.raw,
        formattedName: Value(value('FN')),
        familyName: Value(names.firstOrNull),
        givenName: Value(names.elementAtOrNull(1)),
        organization: Value(value('ORG')),
        primaryEmail: Value(value('EMAIL')),
        primaryPhone: Value(value('TEL')),
      );
      await db
          .into(db.contactCards)
          .insert(
            row,
            onConflict: DoUpdate(
              (_) => row,
              target: [db.contactCards.collectionId, db.contactCards.uid],
            ),
          );
    }
  }
}

class _Record {
  const _Record(this.href, this.uid, this.etag, this.raw, this.component);
  final String href, uid, raw;
  final String? etag;
  final IcalComponent component;
}
