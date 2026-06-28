# F-Droid `NonFreeNet` declaration

This file is the canonical reference for the F-Droid `fdroiddata` recipe
maintainer when adding courrier to F-Droid. Drop the relevant snippet into
the YAML metadata at `metadata/dev.etabli.courrier.yml`.

## Why NonFreeNet applies

courrier ships a **Microsoft 365 OAuth2 provider** in `lib/modules/mail/
providers/microsoft365/`. The provider connects to:

- `https://login.microsoftonline.com/<tenant>` — Microsoft's identity
  endpoint, proprietary network service.
- `outlook.office365.com:993` — Exchange Online IMAP.
- `smtp.office365.com:587` — Exchange Online SMTP.

These are proprietary services controlled by Microsoft. The OAuth client
library (`flutter_appauth`) is itself **MIT-licensed** and wraps the
**open-source AppAuth SDKs (Apache-2.0)**. courrier never uses Microsoft's
proprietary native MSAL binary — `msal_auth` is explicitly banned at the
licence-gate and enforced by a build-time grep test
(`test/modules/mail/providers/microsoft365/isolation_test.dart`).

The provider module is **opt-in** — users who never connect a Microsoft
365 account never hit these endpoints. The rest of the binary speaks
CalDAV / CardDAV / IMAP / Notes-REST / News-API against the user's own
self-hosted servers.

## What the recipe should declare

```yaml
AntiFeatures:
  - NonFreeNet
```

The NonFreeNet anti-feature is informational — it tells the F-Droid user
that the app talks to a proprietary network service. courrier qualifies
on the M365 module alone; everything else stays clean.

## Additional flags

courrier is **paid-upfront** with no in-app purchases on Play / App
Store, and **donation-funded** on F-Droid via Liberapay. The Fastlane
metadata above selects the correct funding link via the
`--dart-define=FUNDING_FLAVOR=liberapay` flag set at the F-Droid build
time (see the recipe `build.gradle.kts` snippet).

## Verifying the M365 isolation

The build-time isolation test should fail closed if any Microsoft
identifier ever leaks outside the provider module:

```
flutter test test/modules/mail/providers/microsoft365/isolation_test.dart
```

If that test stays green, NonFreeNet remains the only anti-feature
courrier carries.
