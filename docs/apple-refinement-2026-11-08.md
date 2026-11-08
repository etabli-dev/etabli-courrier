# Apple and desktop refinement — 2026-11-08

This audit covers the current source checkout, Apple build configuration and desktop keyboard navigation. It does not claim live-account, physical-device, signed-distribution or store acceptance.

## Changes

- Keychain Sharing entitlements are configured for all iOS runner configurations and macOS Debug/Profile/Release. Existing sandbox and network permissions remain in place.
- Both Apple resource phases package the app privacy manifest.
- The macOS preview script and CI explicitly separate ad-hoc review artifacts from team-signed credential-store validation.
- Keyboard navigation opens all seven modules, Settings, Accounts and the new-note editor. F1 and the wide-layout help button show the shortcuts. A macOS minimum window size prevents an unusably small workspace.

## Evidence

- Frozen dependency resolution and analyzer passed; dependency license gate passed for 144 packages.
- Baseline suite: 243 passed, one opt-in live-service test skipped. New keyboard regression passed after correcting focus routing from the shell. A later full suite under severe host contention hit two 30-second PBKDF2 test timeouts; a serial retry still hit one timeout. These retries are not counted as green and the crypto/test timeout configuration is unchanged.
- macOS universal Release preview built successfully. Its ad-hoc signature passed deep strict verification; the packaged privacy manifest matches the source exactly. The preview process remained alive for a 20-second startup check with no exception in its output. A separate uniquely identified audit bundle also survived 20 seconds; macOS logged a temporary-path sandbox-extension warning. Neither startup check exercised real credentials.
- Phone Notes and desktop Notes/help screenshots were visually inspected. The missing Command glyph in the test font was replaced with plain Cmd text.
- Unsigned iOS device Release compiled successfully (Runner.app, 24.7 MB); its packaged privacy manifest matches the source. This does not establish installation or signing acceptance.
- The final incremental macOS preview passed again after limiting the entitlement override to Runner; prior unsigned-resource entitlement warnings are absent.
- CI now compiles iOS simulator Debug and unsigned device Release separately. Exact-commit remote results remain to be checked after publication.
- Final serial regression passed all 12 tests covering keyboard navigation, phone/desktop shell navigation, production notes and all PIN-lock cases (32 seconds). Earlier timeout logs remain retained as load-related failed runs; the complete suite remains an exact-commit CI gate.

The first macOS production build correctly rejected ad-hoc signing with the Keychain capability. A development certificate is required for that configuration. This is not treated as a successful signed build.

## Still open

- Team-signed macOS/iOS Keychain write → restart → read, device authentication and notification delivery.
- Real IMAP/Nextcloud acceptance, Microsoft 365 prerequisites and background sync.
- Clean Windows/Linux installation and notification delivery; desktop two-pane layout.
- Signing/notarization, TestFlight/App Store and other distribution submissions.
