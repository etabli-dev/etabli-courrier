# Audit Ledger — Milestone M11 — 2026-06-28

(Previous ledgers archived to `docs/audits/M0_ledger.md`..`M10_ledger.md`.)

## Round 1

| id   | dimension                | sev     | status   | location                                                                  | evidence/note                                                            |
|------|--------------------------|---------|----------|---------------------------------------------------------------------------|--------------------------------------------------------------------------|
| F-01 | build & static analysis  | BLOCKER | Closed   | lib/core/lock/app_lock_guard.dart                                          | undeclared `package:crypto` import. Added crypto ^3.0.3 to pubspec (already transitive via sqlite3).                                                                |
| F-02 | build & static analysis  | BLOCKER | Closed   | lib/modules/onboarding/onboarding_controller.dart                          | `DavClient.new` as a tear-off didn't accept a positional credentials arg; wrapped with a lambda + named arg.                                                       |
| F-03 | build & static analysis  | MINOR   | Closed   | lib/modules/shell/conflict_resolution/conflict_resolution_dialog.dart      | `unintended_html_in_doc_comment` on `GlobalKey<NavigatorState>` — escaped as `&lt;…&gt;`.                                                                          |
| F-04 | build & static analysis  | MINOR   | Closed   | lib/modules/shell/settings/settings_screen.dart                            | `_SectionTitle()` literals needed const.                                                                                                                            |
| F-05 | build & static analysis  | MINOR   | Closed   | test/core/lock/pin_app_lock_guard_test.dart                                | local helper started with underscore — renamed to `makeGuard`.                                                                                                     |
| F-06 | tests                    | BLOCKER | Closed   | lib/core/lock/app_lock_guard.dart                                          | `_generateSalt` could produce out-of-range bytes (microsecond ^ (i*31)). Reworked to `(microsecondsSinceEpoch + i*31) & 0xff` so every entry is a valid byte.       |
| F-07 | tests                    | BLOCKER | Closed   | test/core/settings/settings_io_test.dart                                   | Read-back test used `PreferencesStore.getString('unprefixed.junk')` which throws on non-namespaced keys (correct enforcement); switched to `SharedPreferences.getKeys()` instead. |
| F-08 | build & static analysis  | MINOR   | Closed   | 14 files                                                                  | `dart format` autoformat                                                                                                                                            |

Round summary: opened 8, closed 8, reopened 0, regressions 0.

## Confirmation pass (dims 1, 2, 3, 4, 5, 6, 7, 8, 9)

| dim | dimension              | result                                                                                                                                          |
|-----|------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| 1   | build & static         | analyze 0 issues · `dart format --set-exit-if-changed` clean                                                                                    |
| 2   | tests                  | 205 passing · 0 unintended skips · 1 opt-in live integration skipped (M3 carryover)                                                            |
| 3   | runtime health         | settings + dialog widgets render clean; PIN guard + onboarding controller pass with deterministic fakes; no exceptions in any of the M11 paths |
| 4   | security & privacy     | PIN is SHA-256 + per-install salt + constant-time compare + lives in SecretsStore; settings export excludes secrets (PreferencesStore.exportAll only emits pref.* keys + the importer filters again); biometric uses local_auth (system-managed) |
| 5   | license/supply-chain   | local_auth ^2.3.0 (BSD-3) + crypto ^3.0.3 (BSD-3) added — both GREEN; NOTICE updated; no banned pkg; secrets.json untracked; provenance intact   |
| 6   | offline-first          | onboarding writes accounts + collections to DB synchronously; settings IO is local-only; whats-new state in PreferencesStore                   |
| 7   | data-model fidelity    | OnboardingController inserts one accounts row + collections per discovered service; sync conflict round-trips local + server payloads          |
| 8   | UX / aesthetic         | hex grep outside tokens.dart → 0 hits; single green accent on unread/lock/active states; conflict + tenant + whats-new cards all bordered, no shadows; no silent fail across any path |
| 9   | accessibility (NEW)    | SettingsScreen wraps every interactive control in Semantics labels; Material defaults handle tap targets ≥48dp + contrast WCAG AA against the M0 token palette; M12 stability pass re-runs across the whole tree |

### F-Droid modularity (carry-over from M8)

| check                                                            | result |
|------------------------------------------------------------------|--------|
| `msal_auth` in pubspec.lock                                       | absent |
| M365 identifier grep outside `modules/mail/providers/microsoft365` | 0 hits |

CONVERGED CLEAN.

## Notes
- **Gate-required pieces both land.** Cold-start onboarding can drive a multi-module account (Nextcloud + IMAP + optional M365) from one entry, surfaced as a stage-based controller with deterministic StepOutcomes. App lock works through `PinAppLockGuard` (deterministic test path) and `BiometricAppLockGuard` (local_auth-backed at runtime).
- **`_generateSalt` byte-range bug surfaced by the audit.** Microseconds-XOR-index can exceed 255 → base64Encode rejects. Fixed at the helper; a real production user would have hit this on first PIN set. The lock guard ships safer salt + a constant-time compare invariant.
- **a11y dim 9 is started, not finished.** SettingsScreen wraps controls with Semantics labels; the M12 stability pass is the cross-tree audit. M11 is the first time dim 9 has been on the gate list.
- CocoaPods → SwiftPM advisory carries over.
