# Audit Ledger — Milestone M13 — 2026-06-28

(Previous ledgers archived to `docs/audits/M0_ledger.md`..`M12_ledger.md`.)

## Round 1

| id   | dimension                | sev     | status   | location                                                  | evidence/note                                                                                                       |
|------|--------------------------|---------|----------|-----------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| F-01 | build & static analysis  | BLOCKER | Closed   | lib/dev/demo_app.dart + demo_services.dart                | first demo-boot pass surfaced unused drift import + missing FeedRepository import + missing FutureBuilder generic + missing EventDraft import. Each closed in place. |
| F-02 | build & static analysis  | MINOR   | Closed   | 2 files                                                   | `dart format` autoformat                                                                                            |

Round summary: opened 2, closed 2, reopened 0, regressions 0.

## Confirmation pass (dims 1, 3, 8, 10)

| dim | dimension              | result                                                                                                                                          |
|-----|------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| 1   | build & static         | analyze 0 issues · format clean                                                                                                                  |
| 3   | runtime health         | DemoServices.bootInMemory smoke test passes — proves demo boot wires every module without exceptions before Maestro ever launches the device   |
| 8   | UX / aesthetic         | hex grep outside tokens.dart → 0 hits; Maestro flows capture both `MAESTRO_COURRIER_THEME=light` and `=dark` so the gallery proves the single accent / borders posture across modes  |
| 10  | documentation          | docs/vignettes/maestro.md landed; covers demo-boot wiring + capture.sh + per-flow expectations + extension instructions                          |

### Tests
- 206 passing (+1 over M12: demo_services_test) · 0 unintended skips · 1 opt-in live integration skipped (M3 carryover)

### Maestro harness inventory
- `.maestro/config.yaml`
- `.maestro/flows/` × 9 (mail_inbox, mail_thread, calendar_agenda, calendar_month, contacts_list, contacts_detail, tasks_list, notes_list, feeds_list)
- `scripts/maestro/capture.sh` (executable; both themes by default; per-theme override)

### F-Droid modularity (carry-over)
- `msal_auth` absent; M365 identifier grep clean

CONVERGED CLEAN.

## Notes
- **Demo boot is dev-only.** `--dart-define=COURRIER_DEMO_BOOT=true` is the only path that loads `lib/dev/demo_app.dart`. Production users never see it. `bool.fromEnvironment` defaults to `false` so release builds reach the standard `AppShell` unchanged.
- **The harness ships YAML + driver; the gallery is device-only.** Capturing the actual PNGs needs Maestro CLI + an emulator/simulator. The smoke test catches "demo boot won't launch" before the device runner does. M15 release-gate ticks the capture box against real iOS + Android devices.
- CocoaPods → SwiftPM advisory carries from M2; M15 polish removes Podfile if we want SwiftPM-only.
