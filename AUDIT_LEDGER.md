# Audit Ledger — Milestone M14 — 2026-06-28

(Previous ledgers archived to `docs/audits/M0_ledger.md`..`M13_ledger.md`.)

## Round 1

| id   | dimension                | sev     | status   | location                                                              | evidence/note                                                                                                       |
|------|--------------------------|---------|----------|-----------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| F-01 | build & static analysis  | MINOR   | Closed   | lib/core/bootstrap/sample_content_installer.dart                       | unused `drift/drift.dart` import (companions reach via the generated database.dart).                                |
| F-02 | build & static analysis  | MINOR   | Closed   | test/core/bootstrap/sample_content_installer_test.dart                 | `FlutterError` needs `flutter/foundation.dart`; trim unnecessary `dart:typed_data` + `dart:async` imports.          |
| F-03 | build & static analysis  | MINOR   | Closed   | 2 files                                                               | `dart format` autoformat                                                                                            |

Round summary: opened 3, closed 3, reopened 0, regressions 0.

## Confirmation pass (dims 1, 2, 10)

| dim | dimension              | result                                                                                                                                          |
|-----|------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| 1   | build & static         | analyze 0 issues · `dart format --set-exit-if-changed` clean                                                                                    |
| 2   | tests                  | 208 passing (+2 over M13: sample_content_installer fresh-install + idempotent-no-op) · 0 unintended skips · 1 opt-in live integration skipped (M3 carryover) |
| 10  | documentation          | 13 vignettes in `docs/vignettes/` covering every module + provider how-tos + shell + screenshots + first-launch sample; **TOC index landed**    |

### M14 deliverables present
- `assets/sample/holidays_2026.ics` (5 all-day events) declared in pubspec.yaml's assets list
- `lib/core/bootstrap/sample_content_installer.dart` — idempotent on "any account exists"; seeds local account + Holidays 2026 calendar + Welcome notes (2 starter notes incl. checklist) + sample feed subscription
- `lib/main.dart` calls `SampleContentInstaller.installIfMissing(db)` before `runApp` on the production path
- `docs/vignettes/index.md` — TOC (12 vignettes linked + sample_content + maestro)
- `docs/vignettes/sample_content.md` — what ships + how to extend + how the installer is wired
- `docs/vignettes/davmail.md` — external-companion how-to for on-prem Exchange + Exchange calendar/contacts as CalDAV/CardDAV
- `test/core/bootstrap/sample_content_installer_test.dart` — fresh-install + idempotent-no-op coverage

### F-Droid modularity (carry-over)
- `msal_auth` absent; M365 identifier grep clean

CONVERGED CLEAN.

## Notes
- **Sample content is a local-only account**, so the installer can't accidentally sync seed data to a user's real server. Deleting the local account from Settings → Accounts removes everything; the next fresh install (after data wipe) re-seeds.
- **Holiday set is universal** (5 globally-recognisable dates). A region-aware `assets/sample/holidays_{LOCALE}.ics` extension is M11 polish; the installer already accepts an optional bundle override so a future locale-driven path drops in cleanly.
- **DavMail vignette stays a how-to** — `courrier` doesn't bundle DavMail (GPLv2 forbidden by LICENSING.md). The vignette is the right surface for users who want to bridge on-prem Exchange or work around tenant policy that blocks OAuth.
- CocoaPods → SwiftPM advisory carries from M2; M15 polish removes Podfile if we want SwiftPM-only.
