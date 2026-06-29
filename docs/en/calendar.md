# Calendar

The Calendar module is the first full vertical slice in `courrier`. It wires the
M1 schema, the M2 DAV layer, and the M2 iCal layer through an offline-first
repository, a CalDAV-shaped sync backend, and a Coder/Hugo-styled UI.

## Surface

- **Agenda view** — chronological list of events with title, date/time,
  human-readable recurrence (e.g. *"Weekly on Monday, Wednesday, and Friday"*)
  and location. Renders the single green accent on the left edge of each tile.
- **Month view** — 7-column grid, week-starts-Monday, with a green dot on any
  day that has at least one event.
- **Event editor** — title, start, end, all-day toggle, location, description,
  raw RRULE string, organiser, attendees (one per line), and any number of
  reminders. Saves through `CalendarRepository`.
- **Recurrence-delete dialog** — when the user deletes a recurring event the
  dialog asks: *this occurrence only*, *this and following*, or *all*. The
  repository encodes the choice as an EXDATE row, an `UNTIL=` truncation, or a
  tombstone respectively.

## Data flow

```
EventEditor → EventDraft → CalendarRepository
                           ├── inserts CalendarEvents + EventReminders + EventRecurrenceOverrides
                           ├── renders VCALENDAR/VEVENT via EventSerializer (M2 IcalWriter)
                           └── enqueues PendingChanges with baseEtag for the optimistic If-Match guard
```

```
CalendarSyncBackend.push  → DavClient.put If-Match → 201 etag updates row,
                                               or 412 PreconditionFailed → SyncConflicts row
CalendarSyncBackend.pull  → SyncCollectionClient.run → changed/deleted hrefs +
                            new sync-token → multiget (M4 onwards wires that next)
```

## Round-trip fidelity (audit dim 7)

The raw ICS is stored verbatim in `CalendarEvents.rawIcs`. Recurrence edits
parse → patch RRULE/EXDATE properties → re-render via the M2 writer, so
unknown vendor properties (`X-WR-CALNAME`, `X-CUSTOM-*`, …) and structural
extras (`VALARM` children, `ORGANIZER`, `ATTENDEE` parameters) survive every
edit.

## RRULE formatter

`RruleFormatter` covers the 95% case Outlook/Apple/Nextcloud users actually
write: FREQ + INTERVAL, BYDAY (with ordinal prefix for *"the 2nd Monday"*),
BYMONTHDAY ordinals, BYMONTH names, COUNT, UNTIL. Anything else (`BYHOUR`,
`BYSETPOS`, `BYYEARDAY`, …) renders as *"Custom recurrence"* — better honest
than misleading.

## DST + all-day

`IcalDateParser` recognises three shapes:

- `VALUE=DATE:20260620` → all-day (no time component).
- `:20260620T100000Z` → UTC instant.
- `;TZID=Europe/Berlin:20260620T100000` → floating local with a tzid label.

The DTSTART/DTEND columns in `CalendarEvents` are the indexed projection — the
raw ICS is still the source of truth. A future M11 pass will introduce a real
TZ database for cross-zone display; M3 already round-trips DST-spanning
events without corrupting them.

## ICS import

`IcsImporter` reads a `.ics` file, iterates `VEVENT` blocks, and upserts each
into a target collection by `(collection_id, uid)`. Re-import is idempotent.
Calendar-level properties on the surrounding `VCALENDAR` (`PRODID`, `VERSION`,
`X-WR-CALNAME`, …) are preserved on the per-row canonical render. The
importer is what M14 will use to ship the bundled holiday ICS as a local-only
calendar on first launch.

## Live round-trip (the M3 gate)

`test/integration/live_nextcloud_calendar_test.dart` exercises
discovery → create → push → pull on a live Nextcloud. It is **opt-in**: the
suite skips when `secrets.json` is missing `NEXTCLOUD_BASE_URL`. To run it:

```
cp secrets.example.json secrets.json   # gitignored — fill in your test values
flutter test --dart-define-from-file=secrets.json \
             test/integration/live_nextcloud_calendar_test.dart
```

Inside the test we:

1. Discover the user's `calendar-home-set` via `.well-known/caldav`.
2. Pick the first writeable calendar collection.
3. Create a one-off VEVENT through `CalendarRepository`.
4. Push pending changes through `CalendarSyncBackend.push` — assert success.
5. Pull through `CalendarSyncBackend.pull` — assert the server etag landed.
6. Clean up by deleting the event server-side.

## Local-only calendars

A `kind=local` account paired with a `kind=calendar` collection skips the sync
path entirely — the repository keeps the row, never enqueues a pending
change, and the UI surface is identical to a synced calendar. This is how the
bundled holiday ICS (M14) and any imported `.ics` files appear on first run
without a network.
