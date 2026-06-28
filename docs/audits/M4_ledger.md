# Audit Ledger — Milestone M4 — 2026-06-28

(Previous ledgers archived to `docs/audits/M0_ledger.md`, `M1_ledger.md`, `M2_ledger.md`, `M3_ledger.md`.)

## Round 1

| id   | dimension                | sev     | status   | location                                                              | evidence/note                                                            |
|------|--------------------------|---------|----------|-----------------------------------------------------------------------|--------------------------------------------------------------------------|
| F-01 | tests                    | BLOCKER | Closed   | test/modules/contacts/data/contact_repository_test.dart::Listing       | UNIQUE constraint failed on (collection_id, uid) when three creates landed in the same millisecond — surfaced a **real production bug** in `_defaultUidGenerator` (used by CalendarRepository + ContactRepository): a bare timestamp UID isn't unique under rapid creates |
| F-02 | data-model fidelity      | BLOCKER | Closed   | lib/modules/calendar/data/calendar_repository.dart, lib/modules/contacts/data/contact_repository.dart | fixed `_defaultUidGenerator`: now `<millisecondsSinceEpoch>-<microsecond>-<process-local counter>@etabli.dev`. Counter monotonic across the process. |
| F-03 | build & static analysis  | MINOR   | Closed   | 9 files                                                               | `dart format` autoformat                                                  |

Round summary: opened 3, closed 3, reopened 0, regressions 0.

## Confirmation pass (dims 1, 2, 3, 4, 5, 6, 7, 8)

| dim | dimension              | result                                                                                                            |
|-----|------------------------|-------------------------------------------------------------------------------------------------------------------|
| 1   | build & static         | analyze 0 issues · `dart format --set-exit-if-changed` clean                                                       |
| 2   | tests                  | 82 passing · 0 unintended skips · 1 opt-in live integration skipped (carried over from M3)                         |
| 3   | runtime health         | widget-test scope only — 3 contact widget tests render clean, no overflows / no exceptions                          |
| 4   | security & privacy     | no secrets in tests; rawVcard treated as opaque; photoBase64 stays in DB (no logs)                                  |
| 5   | license/supply-chain   | no new deps (uses existing drift / http / xml / iCal layer); NOTICE unchanged; no banned pkg; secrets.json untracked|
| 6   | offline-first          | every CRUD path writes to DB first; sync backend drains the queue; UI reads from DB through repo only              |
| 7   | data-model fidelity    | `updateContact preserves unknown X-* properties across an edit` asserts X-IM-SLACK + X-CUSTOM-VENDOR-NOTE survive a save; tests cover photoBase64 + photoUri paths; UID + etag distinct; F-01 surfacing exposed and closed a real UID-collision bug |
| 8   | UX / aesthetic         | hex grep outside tokens.dart → 0 hits; single green accent only; bordered initial chip (borders over shadows) on every list row |

CONVERGED CLEAN.

## Notes
- F-01/F-02 are the most consequential closing of the milestone: the failing test surfaced a production-grade bug that would have shipped silently until two users hit the same millisecond UID. Fixed in both repos at the helper.
- Live CardDAV round-trip is implicitly covered by the M3 live test (DavClient + sync-collection + 412 surface are shared). A contacts-specific live integration test can land at M11 polish.
- CocoaPods → SwiftPM advisory carries over.
