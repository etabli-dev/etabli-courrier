# courrier

A privacy-first, **offline-first** FOSS alternative to the Outlook mobile app, in a single
**Flutter** binary: **email, calendar, contacts, tasks, reminders, notes, RSS** — syncing to
self-hosted **Nextcloud**, with **Microsoft 365 / Exchange Online mail** as a first-class
account type. Member of the **Établi Suite** (`etabli-dev`). Paid-upfront, **no IAP**.
Ships to App Store, Google Play, F-Droid, GitHub Releases.

## Status

Pre-v0.1.0 — being built milestone-by-milestone per `BUILD_PROMPT.md`. Standing rules live
in `CLAUDE.md`. The audit engine lives in `AUDIT_LOOP.md`.

## Build

`courrier` reads runtime config via `String.fromEnvironment(...)` fed by
`--dart-define-from-file`. Copy the template and fill in your own test values:

```
cp secrets.example.json secrets.json     # gitignored — never commit
flutter pub get
flutter run --dart-define-from-file=secrets.json
flutter test --dart-define-from-file=secrets.json
```

The M365 client ID is **public** and may live in source; passwords / app-passwords /
refresh tokens never appear outside `secrets.json` or `flutter_secure_storage`.

See `PREFLIGHT.md` for the locked build decisions and provisioning prerequisites.

## Clean-room provenance

Fossify (Calendar/Contacts/Notes/Clock/Messages/commons), Etar, Tasks.org (all GPL-3.0) and
DavMail (GPL-2.0) were consulted as behavioural / feature references only — **no code copied
or ported**. Thunderbird desktop (MPL-2.0) and K-9 / Thunderbird-Android (Apache-2.0) likewise
informed design only. The only MPL component shipped is the `enough_mail` dependency
(recorded in `NOTICE`). See `THIRD_PARTY_REFERENCES.md`.

### Deliberate divergences (do not "fix" later)

- Single green accent `#28a745` — **no** arbitrary color customisation.
- Paid-upfront, no IAP — **no** freemium / feature-locking UI.
- Own DAV + offline store — **no** dependency on a system PIM provider.

## Licensing

Apache-2.0 (see `LICENSE`). Third-party attributions in `NOTICE`. Banned packages — see
`LICENSING.md`. A CI license gate (`.github/workflows/license-gate.yml`) fails the build on
any RED license or banned package.

## Contributing

Inbound = outbound (Apache-2.0) with DCO sign-off. See `CONTRIBUTING.md`.
