# First-launch sample content (M14)

`courrier` ships with **bundled runnable sample content** so the very
first launch is explorable offline — no accounts, no network, no setup.

## What you see

On first launch, `SampleContentInstaller.installIfMissing(db)` notices
an empty database and seeds:

| module    | content                                                                                  |
|-----------|------------------------------------------------------------------------------------------|
| calendar  | "Holidays 2026" local-only calendar with 5 all-day events (New Year's Day, Labour Day, summer solstice, autumn equinox, winter solstice) loaded from `assets/sample/holidays_2026.ics` via the M3 `IcsImporter` |
| notes     | "Welcome" notes collection with two starter notes ("Getting started", "Checklist demo") |
| feeds     | One subscription pointing at the courrier release-notes feed                              |
| mail      | (no sample mail; mail surfaces require connecting an account from Settings)              |
| contacts  | (no sample contacts; user adds via the editor or CardDAV sync)                           |
| tasks     | (no sample tasks)                                                                         |

The sample content lives under a single `local`-kind account named
"Local sample content". You can delete it at any time from Settings →
Accounts; the next launch won't re-seed because the installer is
idempotent on "any account exists".

## Architecture

`lib/core/bootstrap/sample_content_installer.dart` runs from `main()`
right after the database opens, before the shell builds. The installer:

1. Counts existing accounts. If non-zero → returns immediately.
2. Otherwise creates a `local`-kind account row.
3. Creates a "Holidays 2026" calendar collection on it.
4. Loads the bundled ICS via `rootBundle.loadString(...)` and pipes the
   text through `IcsImporter.importVcalendar`.
5. Creates a "Welcome" notes collection + two starter notes through
   `NoteRepository.createNote`.
6. Subscribes to one sample feed through `FeedRepository.subscribe`.

The asset declaration lives in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/sample/holidays_2026.ics
```

Tests at `test/core/bootstrap/sample_content_installer_test.dart` cover:
- fresh install seeds the expected row counts + holiday titles + all-day
  flags;
- the second `installIfMissing` is a no-op when any account exists (no
  duplicate sample data, no events imported atop a real account).

## Why local-only?

The sample content is for orientation, not the user's real data. Putting
it under a `local`-kind account means:

- It never tries to sync — no surprise traffic to anyone's server.
- The user can delete the whole account without a "this will be deleted
  on the server" prompt.
- A real Nextcloud / IMAP / M365 account added later lives next to it
  with zero interaction (the sample stays as a reference for the user
  to compare against).

## Holiday ICS format

`assets/sample/holidays_2026.ics` is a plain RFC 5545 VCALENDAR with
`VALUE=DATE` (all-day) events and CATEGORIES:Holiday on each. Replace
or extend with a regional holiday set; the importer is robust to
unknown properties + arbitrary timezones (see M2 audit dim 7).

## Try it

1. Wipe the app data (or run a fresh install).
2. Launch the app. The Calendar tab shows "New Year's Day" and four
   other holidays for 2026.
3. Tap the Notes tab → "Getting started" + "Checklist demo".
4. Tap the Feeds tab → "courrier release notes" subscription. Pull-to-
   refresh fetches the actual items if the device has network; otherwise
   the row is still visible (the title alone proves the module is wired).
5. Open Settings → Accounts → connect your own Nextcloud / IMAP / M365.
   The sample account stays as a reference until you delete it.

## Open at M14

- The first-launch sample is identical for every install. M11 polish
  can add a "starter content" toggle in Settings so power users can
  suppress the re-install after wiping.
- A region-aware holiday set (`assets/sample/holidays_{LOCALE}.ics`)
  would replace the universal sample with the locale-correct one;
  trivial extension to the installer.
