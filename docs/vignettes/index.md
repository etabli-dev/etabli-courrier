# courrier vignettes — TOC

Tutorial-grade documentation for every module + the cross-cutting pieces.
Each page is structured the same way: **what it is**, **try it** (first
steps against the bundled sample content), **architecture / data flow**,
**open at this milestone**. Every page links into the Maestro gallery
where applicable.

## First launch

- **[sample_content.md](sample_content.md)** — what ships in the M14
  bundle and what happens on the very first launch.

## Modules (M0..M11 verticals)

- **[mail.md](mail.md)** — IMAP / SMTP read + compose + send, including
  the remote-content-off-by-default render and the demo mail backend
  that drives screenshots + tests.
- **[calendar.md](calendar.md)** — CalDAV VEVENT with agenda + month
  views, RRULE formatter, recurrence-delete dialog, ICS import.
- **[contacts.md](contacts.md)** — CardDAV vCard CRUD + groups + photo,
  with in-place rawVcard patching so unknown properties survive.
- **[tasks.md](tasks.md)** — VTODO with subtasks (RELATED-TO;RELTYPE=PARENT)
  and both fixed-RRULE + repeat-after-completion modes.
- **[reminders.md](reminders.md)** — `flutter_local_notifications`
  scheduling + Android boot-receiver re-arm + iOS cold-start re-arm.
- **[notes.md](notes.md)** — Nextcloud Notes REST with checklist
  round-trip, editor undo/redo, and per-note lock.
- **[feeds.md](feeds.md)** — RSS / Atom via Nextcloud News API primary +
  bundled standalone parser fallback; shared CustomIntervalPicker.

## Provider how-tos

- **[m365.md](m365.md)** — connecting Microsoft 365 via OAuth2 + IMAP/
  SMTP XOAUTH2. Includes the Entra app registration walkthrough.
- **[davmail.md](davmail.md)** — using DavMail as an external companion
  for on-prem Exchange or to surface Exchange calendar / contacts as
  CalDAV / CardDAV that courrier already speaks.

## Shell + onboarding

- **[onboarding.md](onboarding.md)** — single-entry onboarding (Nextcloud
  + IMAP + M365), app lock (PIN + biometric), unified settings, global
  search, sync-conflict resolution UI, What's-New dialog, About + funding
  flavor.

## Screenshots

- **[maestro.md](maestro.md)** — the M13 screenshot harness: demo-boot
  entry point, per-flow YAML, `scripts/maestro/capture.sh` driver,
  light + dark capture.

## Reading order

If you're new to the project: start with `sample_content.md`, then
`onboarding.md`, then pick a module to dive into. The architecture
sections are independent — you can read in any order.
