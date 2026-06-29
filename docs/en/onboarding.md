# Settings + onboarding (M11)

The M11 shell polish brings five things to the surface for the first time:
unified settings + about, app lock (PIN + biometric), settings export/import,
single-entry onboarding (Nextcloud + IMAP + M365 from one screen), global
search, sync-conflict resolution UI, and a What's-New dialog post-update.

## Onboarding from one entry

`OnboardingController` walks the user through three stages, all skippable
and all idempotent:

1. **Welcome** — sets expectations.
2. **Nextcloud** — base URL + app password → `DavDiscovery` runs against
   `.well-known/caldav`, walks principal → home sets → enumeration. One
   `accounts` row is inserted with the kind `nextcloud`; one
   `collections` row per discovered calendar + address book, plus a
   `notes` and `feeds` row so the Nextcloud Notes / News APIs pick them
   up on next pull. App password persists in `SecretsStore`.
3. **IMAP** — email + password → `AutoconfigResolver` (ISPDB → .well-known
   → DNS SRV). Discovered config seeds one `imap`-kind account; the
   password persists in `SecretsStore`.
4. **Microsoft 365** (optional) — runs `M365Backend.signInAndConnect`. On
   `TenantConnected` an `m365`-kind account row is inserted; on any
   tenant-friction state the existing `TenantErrorCard` surfaces an
   actionable next step. **No silent fail.**

Each step emits a `StepOutcome` (`InProgress` / `Skipped` / `Succeeded` /
`Failed`) that streams through `OnboardingController.events`. The shell
listens and routes screens.

## App lock

`core/lock` ships two `AppLockGuard` implementations:

- **`PinAppLockGuard`** — user-set PIN, SHA-256 hashed with a per-install
  salt, persisted via the M1 `SecretsStore`. Constant-time comparison on
  unlock. Tests use an injected `promptForPin` closure so the unlock flow
  runs deterministically.
- **`BiometricAppLockGuard`** — Touch ID / Face ID / Fingerprint via
  `local_auth`. The shell composes the two: if biometric is available +
  enabled, use it; otherwise fall back to PIN.

## Global search

`GlobalSearchService.search(term)` fans out to the indexed columns on
every module table (`calendar_events` summary/location/description,
`contact_cards` formattedName/given/family/org/primaryEmail,
`todo_items` summary/description, `note_items` title/content,
`mail_messages` subject/from/snippet/bodyText, `feed_items`
title/content/author). Hits carry a `SearchModule` enum so the unified
search screen can group them; results are sorted newest-first across
modules. Locked notes show `(locked)` instead of body content — same
posture as the list view.

## Sync-conflict resolution

`DialogConflictResolver` implements the M1 `ConflictResolver` contract.
On any 412 surfaced through `SyncConflicts`, the resolver opens a
`ConflictResolutionDialog` that renders local vs server payload side by
side (truncated to 800 chars + scrollable for the rest) and asks for one
of {`keepLocal` / `keepServer` / `keepBoth` / `defer`}. Closing the
dialog without choosing defaults to `defer` so the conflict stays
recoverable.

## Settings export / import

`SettingsExporter.exportAsJson(store)` serialises every `pref.*` key from
the central `PreferencesStore` into a versioned JSON envelope.
`SettingsImporter.importFromJson(json, store)` reads it back; non-pref
keys are filtered out. **Secrets** (OAuth tokens, app passwords) stay in
`SecretsStore` and never leave the device — only non-sensitive
preferences round-trip.

## What's-New

`WhatsNewService.shouldShow()` returns true exactly once per version. The
shell calls `WhatsNewDialog.showIfNeeded(context, service)` on cold start;
the dialog renders the bullet list of changes M14 will keep in sync with
the canonical CHANGELOG. After dismissal `markSeen()` records the version
so the next launch skips the dialog until the user upgrades.

## About + funding flavor

`AboutInfo.current()` reads `--dart-define=FUNDING_FLAVOR=...` at compile
time:

- `bmc` (default) → "Buy Me a Coffee" + URL — for App Store / Google Play
  / GitHub Releases builds.
- `liberapay` → "Liberapay" + URL — for the F-Droid build (no proprietary
  payment processor).

M15 sets the flavor at build time per Fastlane lane.

## Accessibility (audit dim 9 — first round)

The settings screen wraps every interactive control in `Semantics`
labels so screen readers announce the action. Material defaults handle
tap-target sizing (≥48dp) and contrast (the M0 token palette already
meets WCAG AA against the surface backgrounds). M12 stability pass
re-runs dim 9 across the whole tree.
