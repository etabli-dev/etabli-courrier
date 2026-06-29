---
title: courrier
---

# courrier

A privacy-first, **offline-first** FOSS alternative to the Outlook mobile app, in a
single **Flutter** binary: **email, calendar, contacts, tasks, reminders, notes, RSS**
— syncing to self-hosted **Nextcloud**, with **Microsoft 365 / Exchange Online mail**
as a first-class account type. Member of the **Établi Suite**. Paid-upfront, no IAP.

Source: [github.com/etabli-dev/etabli-courrier](https://github.com/etabli-dev/etabli-courrier)
&middot; Releases: [v0.1.0](https://github.com/etabli-dev/etabli-courrier/releases/tag/v0.1.0)
&middot; License: Apache-2.0

## Vignettes

Tutorial-grade per-module how-tos. Start with the index, jump to whichever module
you're wiring up.

- **[Index]({{ '/vignettes/' | relative_url }})** — table of contents
- **[Sample content]({{ '/vignettes/sample_content/' | relative_url }})** — what ships
  bundled at first launch

### Modules

- [Mail]({{ '/vignettes/mail/' | relative_url }}) — IMAP + SMTP, threading,
  remote-content blocking, soft-delete recycle bin
- [Calendar]({{ '/vignettes/calendar/' | relative_url }}) — CalDAV, RRULE, recurrence
  delete (this / this-and-following / all), ICS import
- [Contacts]({{ '/vignettes/contacts/' | relative_url }}) — CardDAV, photo, groups,
  unknown vCard properties preserved
- [Tasks]({{ '/vignettes/tasks/' | relative_url }}) — VTODO subtasks, fixed + repeat-
  after-completion recurrence
- [Reminders]({{ '/vignettes/reminders/' | relative_url }}) — local notifications,
  re-armed after device reboot
- [Notes]({{ '/vignettes/notes/' | relative_url }}) — Nextcloud Notes REST, checklist,
  editor undo/redo, per-note lock
- [Feeds]({{ '/vignettes/feeds/' | relative_url }}) — RSS / Atom via Nextcloud News
  + bundled standalone parser

### Providers

- [Microsoft 365]({{ '/vignettes/m365/' | relative_url }}) — OAuth2 + IMAP/SMTP
  XOAUTH2 via `flutter_appauth`; F-Droid `NonFreeNet`
- [DavMail companion]({{ '/vignettes/davmail/' | relative_url }}) — external bridge
  for on-prem Exchange or OAuth-blocked tenants

### Shell

- [Onboarding]({{ '/vignettes/onboarding/' | relative_url }}) — single-entry
  Nextcloud + IMAP + M365 setup
- [Screenshot harness]({{ '/vignettes/maestro/' | relative_url }}) — the M13
  demo-boot + Maestro capture script for store listings

## Privacy posture

No analytics, no trackers, no third-party SDKs that collect data. All content stays on
device and on the user's chosen accounts. OAuth tokens + passwords stay in the platform
keystore. Settings export only carries non-sensitive preferences.

The M365 provider module triggers F-Droid's `NonFreeNet` anti-feature (it talks to
proprietary endpoints). The module is optional — users who never connect M365 never
reach those servers.
