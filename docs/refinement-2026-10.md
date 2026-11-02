# October 2026 refinement

## Scope and acceptance

A dependable source-build development candidate for the implemented offline modules, manual Nextcloud sync and IMAP reading. Preserve user records, credentials, source formats and pending changes. Local acceptance requires frozen installation, production-shell journeys, meaningful database/protocol failure tests, analysis, license checks and Android packaging. Full mail composition, Microsoft 365 registration, automatic background sync, general PIM editors and store distribution are separate milestones; their absence must be visible.

## Findings and implemented roadmap

| Finding | Evidence and user impact | Repair and completion criterion |
|---|---|---|
| Release blocker: production destinations were placeholders | `main.dart`, `shell/destinations.dart`; implemented modules were unreachable | Wire all seven modules, database startup/retry and account/settings routes; test real production navigation and durable note editing. |
| High: partial setup and write loss | Sample bootstrap, repositories and onboarding could commit data separately from required follow-up writes | Atomic seed/CRUD + queue transactions; reserve account IDs before secure writes; disabled identity retained if cleanup fails. Inject failure and verify rollback/retry. |
| High: DAV token/data mismatch and credential redirects | Pulls advanced sync tokens without ingesting records; empty properties looked like deletion | Bounded same-origin HTTPS, strict multistatus/tombstones, download/parse before records+token transaction, actual resource hrefs, preserving schema-2 migration. |
| High: stale local/remote identity | Queue acknowledgement could erase a newer edit; mailbox moves/UIDVALIDITY could address another message | Replace intent IDs, preserve preconditions, acknowledge only dispatched work, record uncertain creates before POST, preserve local drafts on pull. Validate mailbox destination UID mapping and archive old generations. |
| High: destructive conflict handling or endless blocked writes | Server preconditions fail, but earlier conflict records promised a nonexistent lazy resolver | Keep the local record in an offline collection before a full reload; stale queue identities cannot discard newer work. No unconditional remote overwrite. |
| High: lock/settings gaps | Production lock callbacks absent; settings import could change lock state | Platform authentication, whole-navigator app lock, protected note access, strict bounded preferences validation/rollback. Locked-note content stays hidden after denied authentication. |
| High: timer/reminder correctness | Cancel-before-rebuild erased alarms on failure; local recurrence used UTC/duration arithmetic | Plan first, schedule before cancellation, retain alarms after failures, device IANA zone, calendar arithmetic across DST, inexact fallback. Device delivery remains unverified. |
| High: release/platform defects | Main manifest lacked network permission; biometric activity/theme requirements absent; release used debug signing | Android permissions/activity/theme, private-content backup exclusion, unsigned-by-default release, explicit private signing, pinned/frozen CI. |
| Medium: source and lifecycle integrity | ICS import dropped overrides; task completion lacked queued source updates; thread/subtask cycles could hang | Preserve unknown ICS/vCard fields and recurrence components; bounded parsing, transactional completion, finite traversal and account-scoped access. |
| Medium: documentation and license drift | README/site advertised unavailable M365/composition; license CI used unpinned unverified flags | Describe actual UI; reviewed checksum/version license inventory for 140 resolved packages and complete Dart license texts. |

Milestone order: restore reproducible toolchain and production shell; repair local writes/mail/reminders; repair account transport and sync; add preserving recovery; validate packaging and align documentation. Reason-first hypotheses and iterations are retained in `BUILD_LOG.md` (F-OCT-01 through F-OCT-15), including the historical records they supersede.

## Observed verification

- Flutter 3.47.9 / Dart 3.13.7 frozen resolution and analyzer pass.
- **238 automated tests pass, one live Nextcloud test is skipped** (`courrier-tests-release`). This includes production shell and note editing/denied unlock; real SQLite schema-1 migration and failed-write rollback; DAV partial-response rollback/403/opaque hrefs/time zones; queue acknowledgement/recovery; IMAP UID identity/archive; onboarding secure-write/cleanup failure; task completion/ICS preservation; settings import and PIN derivation; scheduling failures and Berlin DST transitions.
- The license gate passes for 140 resolved packages (`courrier-license-release`). It checks actual license bytes and versions against the reviewed inventory, including development/desktop dependencies.
- OSV returned no matching advisories for Courrier's final 136 resolved Pub package/version pairs on 2026-10-30 (`courrier-osv-final.json`). The separate earlier three-app audit also found no matches. This does not cover all native SDK dependencies, the local patch itself, or prove the absence of vulnerabilities.
- The native notification suite passes **10 tests**, including three permission-delivery regressions. `:app:lintDebug` with `checkDependencies = true` passes (`courrier-notifications-native-final`). Whole-build lint also exposed standalone secure-storage library manifest/API-floor findings that are satisfied by Courrier's existing USE_BIOMETRIC declaration and minSdk 24; the original failed receipts are preserved. No lint IDs or severities were suppressed.
- Android arm64 debug APK and unsigned release AAB build (`courrier-android-release-check`, `courrier-bundle-release-check`), including the final license-page change. Package inspection confirms API 24 minimum/API 36 target, 16 KiB ZIP/64-bit ELF alignment and no release AAB signing block.
- The real 390 px production screens were captured and visually inspected. Seven clipped phone destinations became four primary destinations plus More, with all seven modules reachable; the wide rail is retained. Local feed removal requires confirmation and preserves the subscription on cancellation. The widget harness explicitly advances Drift's deferred-close timer; interrupted diagnostic runs are marked as non-passing even where Flutter returned zero while shutting down.
- No remote CI, full Xcode build, live-account acceptance, device installation or store submission is implied by these local results.

Raw receipts are in the suite workspace `.refinement/2026-10-30/logs/`; each records the exact command, exit code, UTC start and duration. Earlier failed rounds remain as evidence and are superseded only by a named successful run.

### Published CI outcome — 2026-10-31

Published source commit `7ca7cef025ba3641fc544f1f66eaff5ed9e6813a` passed [application CI](https://github.com/etabli-dev/etabli-courrier/actions/runs/41200136886): Android analysis, tests, APK/AAB packaging and native notification checks, plus the full unsigned iOS compilation. The separate [license gate](https://github.com/etabli-dev/etabli-courrier/actions/runs/41200136888) and [documentation Pages build/deployment](https://github.com/etabli-dev/etabli-courrier/actions/runs/41200136871) also passed. These are observed remote results for that source commit, separate from the local checks above.

Unsigned iOS compilation closes the compilation gate for that revision; installed iOS behavior, private signing, live-account acceptance and store submission remain unverified. Android installation and the unsuccessful interactive attempt are recorded below. No signed application release or store submission occurred.

### Android device attempt — 2026-10-31

The final debug APK installed successfully on the local API 35 arm64 emulator (4 KiB pages), SHA-256 `5562dfb67ba9ce0e9ff8edcb59a6fa76da9392a588828f00d389eb106444b1d6`. Package inspection confirms the enabled launcher, arm64 ABI and API 24 minimum/API 36 target. This later installation evidence does not establish successful app use.

The first startup exceeded its 90-second limit; screenshot and window-service inspection also timed out. After stopping the separate test emulator and idle build JVMs, one bounded retry produced a black screenshot, a null accessibility root and an inaccessible shared-storage mount. Android's crash buffer reported `DeadSystemException` in Courrier, System UI, the keyboard and other services; system logs showed watchdog/lock contention during recovery. A transient activity-resolution failure during that recovery was contradicted by the subsequent installed-package dump, which lists the correct `.MainActivity` launcher. No isolated application exception was established.

Note creation and persistence after restart were not exercised on Android. Production-shell/database tests remain the observed evidence for that behavior. Repeat the prepared note journey on a responsive emulator or physical device, followed by notification permission/delivery and lock lifecycle checks, before claiming device acceptance. Evidence is in `.refinement/2026-10-30/android-local/` (`api35-installs.json`, `flutter-api35-first-attempt.json`, `flutter-api35-retry.json`, `courrier-api35-package.txt`, `flutter-api35-system-failure.log`); `FLUTTER_JOURNEYS.md` there gives runnable steps. API 36/16 KiB runtime execution remains unverified despite the successful package alignment checks.

## Final implementation review

The published notification package 22.3.3 retains unguarded Android posting paths. The reviewed local BSD-licensed source adds permission checking and revocation handling to current and legacy receiver delivery. `third_party/flutter_local_notifications/UPSTREAM.md` records its published archive checksum and replacement criteria. Retire this patch after a compatible upstream fix, then rerun native and application gates.

Settings now exposes packaged open-source licenses. The final APK contains the dependency notices, including enough_mail/enough_convert MPL text and the notification plugin license. The licensing policy corrects the unsupported assertion that Microsoft's native MSAL is proprietary, retains the existing project exclusion, and states the MPL source-availability and platform-review requirements without claiming store acceptance.

## First use and remaining gates

[README](https://github.com/etabli-dev/etabli-courrier/blob/main/README.md) gives exact prerequisites, source-build commands, offline and account workflows, and release signing preparation.

Before release: prepare the signed iOS build with Xcode and private signing material; exercise Nextcloud DAV/Notes/News and a TLS/STARTTLS IMAP test account on installed Android/iOS builds; verify upgrade, device credential denial/cancellation, background/resume, timezone changes and notification permissions; inspect accessibility and secure-store restoration on devices. Review native dependency licenses and final signed packages. A test server/account, device/Xcode environment and private signing material are external dependencies. No credentials were requested or fabricated.

Deferred product work: composition/send UI, Microsoft 365 activation, background/IDLE scheduling, full calendar/contact/task editors, server News read-state mirroring, automated conflict merge and full local-content backup/export. Existing backend seams do not make these production journeys available. Prepare a new version only after acceptance; do not overwrite existing tags or releases.
