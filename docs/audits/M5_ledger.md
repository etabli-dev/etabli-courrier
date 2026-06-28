# Audit Ledger — Milestone M5 — 2026-06-28

(Previous ledgers archived to `docs/audits/M0_ledger.md`..`M4_ledger.md`.)

## Round 1

| id   | dimension                | sev     | status   | location                                                                  | evidence/note                                                            |
|------|--------------------------|---------|----------|---------------------------------------------------------------------------|--------------------------------------------------------------------------|
| F-01 | build & static analysis  | BLOCKER | Closed   | lib/modules/reminders/scheduler/local_notification_scheduler.dart         | flutter_local_notifications v20 changed `initialize(InitializationSettings)` → `initialize(settings:)`, `zonedSchedule(...)` to all-named, and `cancel(int)` to `cancel(id:)`. Updated call sites. |
| F-02 | build & static analysis  | MINOR   | Closed   | lib/modules/tasks/data/task_repository.dart                              | `prefer_const_constructors` on `TaskCompletionOutcome(advancedTo: null)` — replaced with `const TaskCompletionOutcome()`. |
| F-03 | build & static analysis  | MINOR   | Closed   | lib/modules/reminders/reminders_screen.dart                              | `_upcoming` field could be final.                                       |
| F-04 | build & static analysis  | MINOR   | Closed   | test/modules/tasks/data/task_repository_test.dart                        | Unused drift import (Value comes through generated CourrierDatabase).    |
| F-05 | build & static analysis  | MINOR   | Closed   | test files                                                                | redundant `DateTime.utc(…, 1)` day-of-month defaults; const-vs-non-const ScheduledNotification literal. |
| F-06 | tests                    | BLOCKER | Closed   | test/modules/tasks/data/task_repository_test.dart::Completion            | Drift's `DateTimeColumn` round-trips through local-time storage; assertions used UTC comparisons. Fix: compare `.toUtc()` rather than the raw round-tripped value. Same instant in both cases. |
| F-07 | build & static analysis  | MINOR   | Closed   | 11 files                                                                  | `dart format` autoformat.                                                |

Round summary: opened 7, closed 7, reopened 0, regressions 0.

## Confirmation pass (dims 1, 2, 3, 4, 5, 6, 7, 8)

| dim | dimension              | result                                                                                                                          |
|-----|------------------------|---------------------------------------------------------------------------------------------------------------------------------|
| 1   | build & static         | analyze 0 issues · `dart format --set-exit-if-changed` clean                                                                    |
| 2   | tests                  | 92 passing · 0 unintended skips · 1 opt-in live integration skipped (M3 carryover)                                              |
| 3   | runtime health         | rearm + scheduler tests assert no exceptions; widget/list tests render clean                                                    |
| 4   | security & privacy     | scheduler holds no PII beyond the title/body fields the user wrote into events/tasks; FakeScheduler used in all tests so the OS isn't touched |
| 5   | license/supply-chain   | flutter_local_notifications BSD-3 + timezone BSD-2 added — both GREEN; NOTICE updated with version pins; no banned pkg; secrets.json untracked |
| 6   | offline-first          | rearm reads from DB; scheduler is a write-through interface that owns OS state alone                                            |
| 7   | data-model fidelity    | TaskRepository.update + completeTask patch existing rawIcs through M2 reader/writer — `X-TASKS-ORG-REPEAT-COMPLETED` preserved on the repeat-after-completion path. UID + etag distinct |
| 8   | UX / aesthetic         | hex grep outside tokens.dart → 0 hits; single green accent on task tile check + reminder tile edge; reminders permission card surfaces as actionable UI (no silent fail) |

CONVERGED CLEAN.

## Notes
- The "simulated reboot" gate (BUILD_PROMPT M5) is satisfied by `reminder_rearm_service_test.dart::Simulated reboot: rearm against a fresh scheduler matches DB state`: the test clears the scheduler's in-memory state to model an OS-level wipe and asserts `rearmAll()` reproduces the full schedule from the database. The Android manifest path that brings this back to life after a real reboot is wired (`ScheduledNotificationBootReceiver` + `RECEIVE_BOOT_COMPLETED`). iOS keeps schedules across reboot, and `main()` (when wired at M11) calls `rearmAll()` on cold start regardless.
- F-06 is worth flagging in the BUILD_LOG: drift `DateTimeColumn` round-trip is local-time, not UTC. Tests now follow the rule "compare via `.toUtc()` when the production value flows through the DB". This is not a bug, it's a drift contract; documenting so the M6+ tests follow the same idiom.
- CocoaPods → SwiftPM advisory carries over.
