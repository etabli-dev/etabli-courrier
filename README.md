# Établi courrier

> A privacy-first, offline-first Outlook-mobile alternative in one Flutter binary.

`Android` (planned: `iOS` `F-Droid` `Google Play` `App Store`) · Apache-2.0 · Part of the [Établi Suite](https://github.com/etabli-dev)

Établi courrier brings **email, calendar, contacts, tasks, reminders, notes, and RSS** into a single offline-first app that syncs to self-hosted **Nextcloud** and treats **Microsoft 365 / Exchange Online mail** as a first-class account type via XOAUTH2 — no proprietary native MSAL binary, just open-source AppAuth with OAuth2 + PKCE. No analytics, no third-party SDKs, no accounts beyond the ones you connect.

## Availability

Établi courrier v0.1.0 is **released as an Android development build**. App Store, Google Play, and F-Droid releases are planned.

- **Android:** install the signed split-per-ABI **APK** from **[GitHub Releases v0.1.0](https://github.com/etabli-dev/etabli-courrier/releases/tag/v0.1.0)**. Verify with the published `SHA256SUMS.txt`.
- **App Store (iOS):** planned — not yet available.
- **Google Play:** planned — not yet available.
- **F-Droid:** planned — `NonFreeNet` recipe ready in `fastlane/metadata/android/FDROID_NONFREENET.md`.

## Privacy

No analytics. No third-party SDKs that collect data. No accounts beyond the ones the user chooses to connect. All content stays on device and on the user's chosen Nextcloud / M365 / IMAP account. OAuth tokens and passwords live only in the platform secure store (iOS Keychain / Android `EncryptedSharedPreferences`). Settings export only carries non-sensitive preferences.

The Microsoft 365 provider is optional and triggers F-Droid's `NonFreeNet` anti-feature — users who never connect M365 never reach proprietary endpoints.

## Documentation

Hosted site: **<https://etabli-dev.github.io/etabli-courrier/>** — built with Quarto by `.github/workflows/pages.yml` from the [`docs/`](docs/) tree on every push to `main`.

## Repository layout

```
lib/         app, modules, shell, core
android/     Android runner
ios/         iOS runner (planned)
docs/        Quarto site source — en/, theme/, assets/, _quarto.yml
fastlane/    store + F-Droid listing metadata
test/        208 unit + integration tests
assets/      sample content (bundled holidays, demo mail, etc.)
.fdroid.yml  (planned — F-Droid main-repo submission)
```

## Tech

Dart 3.x · Flutter · `drift` (SQLite) · `enough_mail` (MPL-2.0, the only MPL dep) · `flutter_appauth` (OAuth2 PKCE) · `flutter_local_notifications` · `flutter_secure_storage` · `local_auth` · hand-rolled CalDAV / CardDAV / iCal RFC 5545 / vCard RFC 6350 layers · `rrule` for recurrence · Nextcloud Notes REST · Nextcloud News API. **Forbidden:** `msal_auth` and any wrapper of Microsoft's proprietary MSAL binary.

## Support development

- 💚 **[Liberapay](https://liberapay.com/rabanheller/)** — recurring, 0% commission. To be shown on the F-Droid listing once published.

## License

Apache License 2.0 — see [LICENSE](LICENSE) and [NOTICE](NOTICE). Third-party provenance in [THIRD_PARTY_REFERENCES.md](THIRD_PARTY_REFERENCES.md). The clean-room posture (which GPL refs were consulted vs which MPL deps are linked) is in [LICENSING.md](LICENSING.md).

Copyright 2026 R. Heller.
