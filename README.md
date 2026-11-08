# Établi Courrier

An offline communication workspace for mail, calendar, contacts, tasks, reminders, notes and feeds. Flutter source for Android, iOS, Linux, Windows and macOS; Apache-2.0, with separately licensed dependencies.

This source tree includes the October 2026 refinement. The existing v0.1.0 development release does **not** contain these changes. Store/F-Droid acceptance, physical-device operation and live-account interoperability are not yet verified for this revision.

## Platforms

Android and iOS are the existing mobile targets. Linux, Windows and macOS desktop targets were added in November 2026: the Linux build runs and packages as a `.deb` (`scripts/package-deb.sh`), macOS has a locally compiled and startup-checked ad-hoc preview, while Windows remains a CI build target without local acceptance. On desktop, app lock is unavailable on Linux and reminder notifications are not delivered on Linux or Windows; the app shows this where it applies. Status, build commands, signing prerequisites and milestones for all five platforms are in the [platform roadmap](docs/platform-roadmap.md).

## What is available

- **Mail:** connect a TLS or STARTTLS IMAP account, manually refresh the latest 100 envelopes in each folder, and open a message to download its body. Cached messages remain readable offline. A changed mailbox UIDVALIDITY preserves old messages in a separate local archive. Sending, mailbox administration and background/IDLE sync are not exposed in the production UI.
- **Calendar and contacts:** browse cached/local records and manually pull configured Nextcloud DAV collections. Source ICS/vCard fields and resource identities are preserved. Full editing/import screens remain outside the current production interface.
- **Tasks:** browse tasks and mark them complete, including repeat-after-completion tasks. Completion updates local ICS and queues a conditional server write. Task creation/editing UI is deferred.
- **Notes:** create and edit local or Nextcloud notes, including checklists, favorites and per-note device authentication. Drafts remain visible after save failure. A lock controls access in this app; it does not encrypt the SQLite database or the server copy.
- **Reminders:** show upcoming saved event reminders and task deadlines; request notification permission and reload the schedule. With existing permission, schedules refresh on app startup, resume and saved calendar/task changes. Android uses inexact scheduling when exact-alarm permission is unavailable. Device alarm/background/DST operation still requires acceptance testing.
- **Feeds:** add or remove an HTTPS RSS/Atom feed and refresh local subscriptions, or refresh Nextcloud News from Accounts. Read cached articles as text. Read state is local; automatic polling and server read-state mirroring are deferred.
- **Accounts and settings:** verify incoming access before enabling an account, retain credentials in platform secure storage, manually sync, disconnect while keeping cached data, use device-authenticated app lock, and import/export non-sensitive preferences.

Microsoft 365 OAuth remains an unenabled provider module pending project-owned tenant registration and device validation. It is not an available account type in this production screen. SMTP/OAuth implementation tests do not establish a usable sending or sign-in journey.

## First use from source

Prerequisites: Flutter **3.47.9** / Dart **3.13.7**, Python 3, JDK **17**, Android SDK platform **36**, build-tools **35.0.0**, and an Android device/emulator for installation. Set `JAVA_HOME` and `ANDROID_HOME`; accept the SDK licenses. iOS additionally requires a full Xcode installation and a suitable destination.

```sh
flutter pub get --enforce-lockfile
python3 tool/check_licenses.py
flutter analyze --no-pub
flutter test --no-pub
flutter build apk --debug --no-pub --target-platform android-arm64
adb install -r build/app/outputs/flutter-apk/app-debug.apk
# Or run on a connected development device:
flutter run
```

Open the app to explore the bundled offline examples. On phones, **More** opens the complete module list; wider screens use the side rail. In **Notes**, open the sample note, edit it, save, and reopen it. In **Accounts**, connect your canonical HTTPS Nextcloud base URL (including any installation subfolder), username and app password, then select **Refresh**. Notes and News need the corresponding server apps. For IMAP use autoconfiguration or explicit secure host/port settings; credentials are sent only after TLS/STARTTLS establishes transport protection.

Sync is explicit. Errors preserve cached records and pending edits. **Accounts → Pending edits / recovery** can preserve a conflicted local record in a separate offline collection before a full server reload. It never forces an overwrite of an unseen remote version. A failed create whose response was lost requires review, because the server may already have accepted it.

## Data, privacy and recovery

No analytics or author-operated account service is configured. Connected servers and feed URLs receive their requested network traffic; mail autoconfiguration contacts provider discovery services. Application dependencies are listed in `pubspec.lock` and the license manifest. Passwords/tokens use platform secure storage; the content database itself is not encrypted by this app. App lock and note lock use the device authentication prompt.

Authenticated HTTP requests require HTTPS, reject cross-origin redirects, and enforce response-size/time bounds. Disconnection keeps cached content. Android automatic backup/device-transfer is excluded to avoid copying private content or restoring unusable secure-store keys. Settings JSON is **not** a content backup and cannot change lock state or include credentials. Full content backup/export is deferred; retain server-side backups and do not uninstall an app containing unique local data.

The schema-2 upgrade adds DAV resource hrefs while retaining existing records. It resets old DAV tokens so the next sync can fetch the resources that earlier builds never ingested. Migration, rollback, recovery and failed-write behavior have local SQLite tests; an installed-device upgrade is a separate gate.

## Verification and release preparation

See [the refinement record](docs/refinement-2026-10.md) for exact observed checks, findings and remaining requirements, and [BUILD_LOG](BUILD_LOG.md) for the reason-first repair history.

CI is pinned to the tested Flutter version and uses frozen dependency resolution, analysis, tests, license verification, Android builds and lint, plus an unsigned iOS build; that application workflow passed remotely for `7ca7cef` on 2026-10-31 (see the refinement record). The desktop workflow builds Linux (`.deb`), Windows (ZIP and unsigned MSIX) and macOS (ZIP and DMG, not notarized) review artifacts; it has not run remotely yet. The live Nextcloud integration test is intentionally conditional on test-account configuration; a skipped test is not live-service evidence.

```sh
# Produces an unsigned bundle when no private keystore is configured:
flutter build appbundle --release --no-pub
(cd android && ./gradlew --no-daemon :flutter_local_notifications:testDebugUnitTest :app:lintDebug)
# Xcode required; not locally verified here:
flutter build ios --debug --no-codesign --no-pub
```

For signing, create the ignored `android/keystore.properties` with `storeFile`, `storePassword`, `keyAlias` and `keyPassword`. Paths are relative to `android/`. A release never falls back to the debug key. The manual **Prepare signed release artifacts** workflow requires the four documented `COURRIER_*` repository environment secrets; it prepares artifacts without publishing them. First complete live-service/device/upgrade checks, review the signed package and notices, then authorize publication with a new version. Preserve existing tags and releases.

## License

[Apache-2.0](LICENSE). [NOTICE](NOTICE), [resolved license texts](THIRD_PARTY_LICENSES.md), [licensing process](LICENSING.md), and [source provenance](THIRD_PARTY_REFERENCES.md). `enough_mail`, `enough_convert` and desktop-only `dbus` are resolved MPL-2.0 dependencies; native plugin SDKs retain their own notices.

Copyright 2026 R. Heller.
