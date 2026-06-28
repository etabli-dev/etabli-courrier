# Audit Ledger — Milestone M3 — 2026-06-27

(Previous ledgers archived to `docs/audits/M0_ledger.md`, `M1_ledger.md`, `M2_ledger.md`.)

## Round 1

| id   | dimension                | sev     | status   | location                                                | evidence/note                                                            |
|------|--------------------------|---------|----------|---------------------------------------------------------|--------------------------------------------------------------------------|
| F-01 | build & static analysis  | BLOCKER | Closed   | lib/modules/calendar/data/calendar_repository.dart      | runaway placeholder-forwarding chain on first draft; rewrote clean with direct M2 IcalWriter import |
| F-02 | build & static analysis  | BLOCKER | Closed   | event_serializer.dart, calendar_repository.dart         | 11× `unnecessary_brace_in_string_interps` on date formatters — collapsed |
| F-03 | build & static analysis  | BLOCKER | Closed   | agenda_view.dart                                        | `_` pair pattern → `unnecessary_underscores`                             |
| F-04 | build & static analysis  | BLOCKER | Closed   | month_view.dart                                         | `prefer_const_declarations` on dayLabels                                  |
| F-05 | build & static analysis  | BLOCKER | Closed   | recurrence_delete_dialog.dart                           | dialog body fully const                                                  |
| F-06 | build & static analysis  | BLOCKER | Closed   | test/integration/live_nextcloud_calendar_test.dart      | `isNotNull` ambiguous (drift vs matcher) → hide; const DavCredentials/Value; unused import |
| F-07 | build & static analysis  | BLOCKER | Closed   | test/modules/calendar/data/calendar_repository_test.dart | `isNotNull` ambiguous; redundant `DateTime.utc(…,1)` day defaults        |
| F-08 | build & static analysis  | BLOCKER | Closed   | test/modules/calendar/import/ics_importer_test.dart     | unused drift import                                                      |
| F-09 | build & static analysis  | BLOCKER | Closed   | test/modules/calendar/ui/agenda_view_test.dart          | redundant `null` for nullable defaults                                   |
| F-10 | tests                    | BLOCKER | Closed   | rrule_formatter "Daily, 10 times"                       | `parts.join(' ')` introduced a space before the tail comma; restructured to a StringBuffer with no leading space on tail |
| F-11 | tests                    | BLOCKER | Closed   | rrule_formatter "Custom recurrence"                     | rrule package throws `RangeError` (not just `FormatException`) on malformed input; broadened catch to `on Object` |
| F-12 | build & static analysis  | MINOR   | Closed   | 19 files                                                | `dart format` autoformat                                                  |

Round summary: opened 12, closed 12, reopened 0, regressions 0.

## Confirmation pass (dims 1, 2, 3, 4, 5, 6, 7, 8)

| dim | dimension              | result                                                                                                          |
|-----|------------------------|-----------------------------------------------------------------------------------------------------------------|
| 1   | build & static         | analyze 0 issues · `dart format --set-exit-if-changed` clean · 0 deprecations                                  |
| 2   | tests                  | 71 passing · 0 skipped at the unit/widget level · 1 opt-in integration skipped (see §3)                        |
| 3   | runtime health         | n/a at M3 (live emulator run gated on M11 shell wiring); per-widget test runtime had no overflows / no exceptions in the 4 calendar widget tests |
| 4   | security & privacy     | secrets.json untracked; no token in logs; integration test reads creds from `flutter_secure_storage`-bound dart-defines only |
| 5   | license/supply-chain   | rrule MIT, intl BSD-3, transitive time Apache-2.0 — all GREEN; NOTICE updated with version pins; no banned pkg |
| 6   | offline-first          | every CRUD path writes to the DB first; sync backend drains a queue; UI reads from the DB through repo only    |
| 7   | data-model fidelity    | recurrence-delete keeps unknown vendor props via M2 reader/writer round-trip (no re-render from scratch); UID + etag distinct; EXDATE/RECURRENCE-ID surviving asserted in calendar_repository_test.dart |
| 8   | UX / aesthetic         | hex grep outside tokens.dart → 0 hits; agenda uses single green accent on left edge + month-grid event dot; borders over shadows in MonthView _DayCell |

CONVERGED CLEAN.

## Integration test status (M3 GATE)
- `test/integration/live_nextcloud_calendar_test.dart` is wired and **opts in** when `secrets.json` provides `NEXTCLOUD_BASE_URL`. The unit/widget suite reports it as a single skip with the message: *"secrets.json missing NEXTCLOUD_* — set to opt-in to live test"*.
- To run the live gate locally:
  ```
  cp secrets.example.json secrets.json && $EDITOR secrets.json
  flutter test --dart-define-from-file=secrets.json \
               test/integration/live_nextcloud_calendar_test.dart
  ```
- The gate runs: discovery → create → push → pull → assert server etag landed → cleanup.

## Open questions / advisories
- The opt-in integration test cannot be exercised without your `secrets.json` — flagging so you can run it (or hand me populated secrets and I'll run it before STOP).
- CocoaPods → SwiftPM transition advisory (carried over from M2) — deferred to M11 polish.
