# Maestro screenshot harness

![Mail inbox captured against the M13 demo backend](../_screens/0.1.0/01-mail.png){width=320}

courrier ships a Maestro-driven screenshot harness that captures every
module in light + dark mode against the in-memory demo data. The output is
the gallery the store listings and the M14 vignette doc embed.

The v0.1.0 gallery under `docs/_screens/0.1.0/` was captured on an Android
emulator (Pixel AVD, arm64-v8a, API 35) by an adb-driven capture pass: the
demo APK is built with `--dart-define=COURRIER_DEMO_BOOT=true`, installed,
launched, and each tab is selected in turn while `adb exec-out screencap -p`
deposits a PNG per module. The Maestro flows under `.maestro/flows/` are
the canonical harness for CI + light/dark parity; the adb pass is the
faster sibling for v0.1.0 doc capture.

## Why a separate demo boot?

The production app shell is wired against live accounts (Nextcloud, IMAP,
M365) — useful for users, awkward for screenshots. M13 adds a parallel
entry point:

- `--dart-define=COURRIER_DEMO_BOOT=true` makes `main()` route into
  `lib/dev/demo_app.dart`, which:
  - builds an in-memory `CourrierDatabase`,
  - seeds one local account + collections + realistic per-module sample
    data (`lib/dev/demo_services.dart::DemoServices.bootInMemory`),
  - wires every module's screen directly without an account orchestrator.
- `--dart-define=COURRIER_DEMO_DARK=true` flips the theme to dark.

The production path is unchanged — the demo boot lives in `lib/dev/`,
imports nothing from `lib/dev/` flow back into `lib/modules/`, and the
default `bool.fromEnvironment(...)` resolves to `false` for release
builds.

## What's in the harness

Flows under `.maestro/flows/` — one YAML per representative state per
module:

| flow                  | module    | what it captures                         |
|-----------------------|-----------|------------------------------------------|
| mail_inbox.yaml       | mail      | INBOX thread list                         |
| mail_thread.yaml      | mail      | expanded thread + remote-img placeholder |
| calendar_agenda.yaml  | calendar  | agenda view across two weeks              |
| calendar_month.yaml   | calendar  | month grid with the green-dot indicator   |
| contacts_list.yaml    | contacts  | alphabetical list                         |
| contacts_detail.yaml  | contacts  | detail with Email / Phone / Address       |
| tasks_list.yaml       | tasks     | task list with subtask nesting            |
| notes_list.yaml       | notes     | favorites-first + locked-note example     |
| feeds_list.yaml       | feeds     | subscription list with unread chip        |

Each flow uses `${MAESTRO_COURRIER_THEME}` in the screenshot name so the
driver script can run light + dark passes back-to-back into a single
`build/screenshots/` directory.

## Capturing the gallery

```
scripts/maestro/capture.sh              # both themes
scripts/maestro/capture.sh light        # light only
scripts/maestro/capture.sh dark         # dark only
```

Prerequisites:
- Maestro CLI installed (https://maestro.mobile.dev/getting-started/installing-maestro).
- An emulator / simulator running (`flutter devices` shows it).
- `secrets.json` populated at the repo root.

The script (re-)installs the demo-boot variant per theme, runs every
Maestro flow, and drops PNGs into `build/screenshots/<theme>/`. M14
embeds the resulting gallery into the per-module vignettes; M15 carries
the gallery into the store listings.

## Adding a new flow

1. Add the YAML under `.maestro/flows/`.
2. Use `tapOn: { id: "demo-<tab>-tab" }` to switch tabs (every
   destination in `DemoApp` carries a `ValueKey('demo-<label>-tab')`).
3. Use `takeScreenshot: "<flow>_${MAESTRO_COURRIER_THEME}"` so the driver
   script's theme split picks up both passes.
4. Run `scripts/maestro/capture.sh` to refresh the gallery.

## What the smoke test catches

`test/dev/demo_services_test.dart::DemoServices.bootInMemory wires every
module without exceptions` runs as part of the standard suite. It proves
the demo boot path compiles + every repository surfaces seeded rows
without throwing — so the Maestro harness doesn't crash on launch even
when the device runner can't.

## Open at M13

- Capturing the actual PNGs requires a connected device + Maestro
  installed (neither is in CI yet). The YAML harness is the artefact M13
  ships; M15 release-gate ticks the *"gallery generated"* row off
  `docs/audits/M15_jank_checklist.md`-style checklist by running the
  script against real iOS + Android devices.
- A GitHub Actions workflow that boots an emulator + runs the harness
  per PR is M11 polish from `docs/audits/M15_jank_checklist.md` — out of
  scope for M13.
