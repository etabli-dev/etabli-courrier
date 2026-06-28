# Audit Ledger — Milestone M2 — 2026-06-27

(Previous ledgers archived to `docs/audits/M0_ledger.md`, `docs/audits/M1_ledger.md`.)

## Round 1

| id   | dimension                | sev     | status   | location                            | evidence/note                                                            |
|------|--------------------------|---------|----------|-------------------------------------|--------------------------------------------------------------------------|
| F-01 | build & static analysis  | MINOR   | Closed   | 12 files                            | `dart format` autoformat applied after writing M2 layer; now stable      |

Round summary: opened 1, closed 1, reopened 0, regressions 0.

(No analyzer errors / warnings / infos surfaced on round 1 outside of formatting. All M2 code passed `flutter analyze` immediately after each block. Tests passed on first run — 40/40 including 14 new M2 tests.)

## Confirmation pass (dims 1, 2, 5, 7)

| dimension                | result                                                              |
|--------------------------|---------------------------------------------------------------------|
| 1 — build & static       | analyze 0 issues · format clean · 0 deprecations                    |
| 2 — tests                | 40/40 passing · 0 skipped — adds 14 M2 tests covering iCal/vCard round-trip (unknowns preserved), VEvent/VTodo/VCard lenses, RFC 5545 §3.1 line folding incl. multi-byte UTF-8 boundary safety, malformed-input rejection, multistatus parsing (principal/home/enumeration/sync-collection), DavClient PUT 201/412/UnauthorizedError, DELETE etag guard, DavDiscovery chain, SyncCollectionClient happy + transparent 403 token-reset retry |
| 5 — license/supply-chain | http (BSD-3) + xml (MIT) GREEN; NOTICE updated; no banned pkg; secrets.json untracked; provenance file present |
| 7 — data-model fidelity  | round-trip preserves X-CUSTOM-VENDOR-FIELD on VEVENT, X-WR-CALNAME/X-WR-TIMEZONE on VCALENDAR, X-TASKS-ORG-REPEAT-COMPLETED on VTODO, X-IM-SLACK / X-CUSTOM-VENDOR-NOTE on VCARD; EXDATE (×2), RECURRENCE-ID, RELATED-TO (with and without RELTYPE), ORGANIZER, ATTENDEE (×2 with CN/PARTSTAT/ROLE params), nested VALARMs (×2 with TRIGGER/ACTION/DESCRIPTION). UID + etag distinct; property order preserved. |

CONVERGED CLEAN.
