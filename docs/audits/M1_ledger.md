# Audit Ledger — Milestone M1 — 2026-06-27

(Previous M0 ledger archived to `docs/audits/M0_ledger.md`.)

## Round 1

| id   | dimension                | sev     | status   | location                                                | evidence/note                                                                          |
|------|--------------------------|---------|----------|---------------------------------------------------------|----------------------------------------------------------------------------------------|
| F-01 | build & static analysis  | BLOCKER | Closed   | lib/core/db/database.dart                               | dropped `import package:sqlite3` (only used `tempDirectory` — non-essential)           |
| F-02 | build & static analysis  | BLOCKER | Closed   | lib/core/net/net_error.dart                             | added `String get kind` per subclass; `toString()` no longer uses `runtimeType`        |
| F-03 | build & static analysis  | BLOCKER | Closed   | lib/core/sync/account_orchestrator.dart                 | initializing formals on db/connection/resolver (now public fields)                     |
| F-04 | build & static analysis  | BLOCKER | Closed   | test/core/db/database_test.dart                         | added `import package:drift/drift.dart hide isNull` for `Value(...)` (hide vs matcher) |
| F-05 | build & static analysis  | BLOCKER | Closed   | test/core/db/database_test.dart                         | replaced `DateTime.utc(2030, 1, 1)` with `DateTime.utc(2030)` (defaults)               |
| F-06 | build & static analysis  | BLOCKER | Closed   | flutter_secure_storage 9.x → 10.x                        | upgraded; SwiftPM "future error" warning replaced by advisory CocoaPods removal hint   |
| F-07 | build & static analysis  | BLOCKER | Closed   | lib/core/config/secrets_store.dart:10                   | FSS v10 deprecated `encryptedSharedPreferences: true` — removed (auto-migrated)        |
| F-08 | build & static analysis  | MINOR   | Closed   | 27 files                                                | `dart format` autoformat — applied once, now `--set-exit-if-changed` clean             |

Round summary: opened 8, closed 8, reopened 0, regressions 0.

## Confirmation pass (dims 1, 2, 5, 6)

| dimension                  | result                                                              |
|----------------------------|---------------------------------------------------------------------|
| 1 — build & static         | analyze 0 issues · format `--set-exit-if-changed` clean             |
| 2 — tests                  | 20/20 passing · 0 skipped (drift schema_v1 round-trip, NetError mapping, AccountOrchestrator dispatch/offline/412, ConflictResolver, AppShell adaptive layout) |
| 5 — license/supply-chain   | no banned pkg · `secrets.json` untracked · NOTICE current (drift, sqlite3_flutter_libs, FSS v10, shared_preferences, path_provider, path, meta, cupertino_icons added) |
| 6 — offline-first          | no module-level HTTP/socket calls — all UI reads/writes go through `core/db`. Sync engine routes through `core/sync` skeleton only. |

CONVERGED CLEAN.

## Advisory (non-blocking, not a finding)
- `flutter pub get` emits an informational suggestion to drop CocoaPods now that all plugins ship SwiftPM. Not a deprecation, not a warning — just an optimisation hint. Capture in BUILD_LOG and revisit at M11 polish.
