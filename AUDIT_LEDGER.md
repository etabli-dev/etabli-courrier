# Audit Ledger — Milestone M15 — RELEASE GATE — 2026-06-28

(Previous ledgers archived to `docs/audits/M0_ledger.md`..`M14_ledger.md`.)

## Round 1 — Final global pre-release audit (AUDIT_LOOP.md §6)

| id | dimension | sev | status | location | evidence/note |
|----|-----------|-----|--------|----------|---------------|
| F-01 | license/supply-chain | MINOR | Closed | NOTICE | `crypto ^3.0.3` (added at M11 for the PIN app lock) wasn't enumerated. Added between `meta` and `cupertino_icons`. |

Round summary: opened 1, closed 1, reopened 0, regressions 0.

## Confirmation pass — all 10 dimensions, whole app

| dim | dimension              | result                                                                                                                                          |
|-----|------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| 1   | build & static         | analyze 0 issues · `dart format --set-exit-if-changed` clean                                                                                    |
| 2   | tests                  | 208 passing · 0 unintended skips · 1 opt-in live integration skipped (M3 carryover)                                                            |
| 3   | runtime health         | M12 documented; M15 jank checklist at `docs/audits/M15_jank_checklist.md` for the release-gate device pass                                       |
| 4   | security & privacy     | no print/debugPrint anywhere in lib/; PrivacyInfo.xcprivacy declares no tracking + no third-party data collection + the required-reason APIs in use |
| 5   | license/supply-chain   | NOTICE final — every shipped dep enumerated (drift, enough_mail MPL, flutter_appauth, flutter_local_notifications, flutter_secure_storage, html, http, intl, local_auth, meta, crypto, cupertino_icons, path, path_provider, rrule, shared_preferences, sqlite3_flutter_libs, timezone, xml); no banned pkg (`msal_auth` absent); secrets.json untracked; provenance file intact |
| 6   | offline-first          | every persistent module has a `*_repository.dart` writing DB-first; sample-content installer seeds local-only data; sync drains the pending queue |
| 7   | data-model fidelity    | `rawIcs` / `rawVcard` preserved; M2 reader/writer round-trips unknowns; UID + etag distinct                                                    |
| 8   | UX / aesthetic         | hex grep outside tokens.dart → 0 hits; single green accent; borders over shadows; tenant/M365/permission cards all surface actionable next-steps |
| 9   | accessibility          | every IconButton carries `tooltip`; SettingsScreen wraps controls with Semantics; Material defaults handle tap targets ≥48dp + WCAG AA contrast |
| 10  | documentation          | 13 vignettes in `docs/vignettes/` covering every module + provider how-tos + shell + screenshots + first-launch sample (TOC at `index.md`)     |

### F-Droid modularity (M15-specific gate)
- `msal_auth` in pubspec.lock → **absent** (banned).
- M365 identifier grep outside `lib/modules/mail/providers/microsoft365/` → **0 hits** (advisory grep in CI + build-time `isolation_test.dart` hard gate).
- `NonFreeNet` declaration document at `fastlane/metadata/android/FDROID_NONFREENET.md` for the F-Droid recipe maintainer.
- Provider module is opt-in (users who never connect M365 never hit the proprietary endpoints).

### Release artefacts present
- `ios/Runner/PrivacyInfo.xcprivacy` — Apple privacy manifest declaring no tracking + the required-reason APIs.
- `fastlane/metadata/android/en-US/{title,short_description,full_description,changelogs/1.txt}` — Google Play / F-Droid metadata.
- `fastlane/metadata/android/FDROID_NONFREENET.md` — anti-feature reference for the F-Droid recipe.
- `.github/workflows/release-apk.yml` — split-per-ABI APK build + AAB build + SHA256SUMS + GitHub Release on `v*` tag push.
- `.github/workflows/license-gate.yml` — license allow-list + banned-pkg + secrets-untracked + NOTICE-has-MPL + provenance + M365 isolation advisory.

CONVERGED CLEAN. **RELEASE READY.**

## Release-cut readiness (BUILD_PROMPT M15 gate)

- [x] PrivacyInfo.xcprivacy present
- [x] Fastlane F-Droid metadata structured + NonFreeNet declared
- [x] Funding surfaces flavor-aware (`--dart-define=FUNDING_FLAVOR=bmc|liberapay` in AboutInfo; CI uses `bmc` by default; F-Droid recipe overrides)
- [x] NOTICE final (every shipped dep + MPL entry + OAuth deps)
- [x] Split-per-ABI APK CI workflow committed
- [x] Final global audit converged clean (1 round)
- [x] License gate green
- [x] No banned package
- [x] F-Droid modularity intact (NonFreeNet declared on M365 module only)

## Open items the M15 device-gate must tick before announcing the release

These need a real iOS + Android device — the unit + widget suite proves the
engine, the device pass proves the user experience:

- `docs/audits/M15_jank_checklist.md` — 14 device flows (mail scroll, calendar
  swipe, contacts list, onboarding cold-start, lock unlock, reminder fire +
  reboot re-arm, etc.). Run in profile mode.
- `scripts/maestro/capture.sh` — produces the M13 gallery for store listings.
- M3 opt-in live integration test (`test/integration/live_nextcloud_calendar_test.dart`)
  with populated `secrets.json`.
- Apple Developer Program enrollment + Google Play Console enrollment +
  signing config (the M0 build.gradle.kts uses debug signing for release;
  switch before submitting).

## Standing invariants verified at the release gate

- Hex literals only in `lib/core/theme/tokens.dart`.
- M365 identifiers only in `lib/modules/mail/providers/microsoft365/`.
- `msal_auth` banned.
- `secrets.json` gitignored + untracked.
- NOTICE current; every shipped dep enumerated; MPL `enough_mail` entry present.
- THIRD_PARTY_REFERENCES.md clean-room provenance intact (Fossify / Etar / Tasks.org / DavMail / Thunderbird / K-9 references documented).
- No GPL / AGPL / LGPL in the resolved dependency tree.
