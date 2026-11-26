# THIRD_PARTY_REFERENCES.md — clean-room provenance

The following open-source projects were **consulted as behavioral and feature references
only** during the design of `courrier`. **No source code was copied, ported, or closely
transcribed from any of them.** Only non-copyrightable facts — data-model field
requirements, protocol behaviors, and UX flows — informed an independent Dart
implementation. This record documents good-faith clean-room practice.

| Project | Org/Source | License | What was learned (concept only) |
|---|---|---|---|
| Fossify Calendar | github.com/FossifyOrg/Calendar | GPL-3.0 | event field completeness; multiple reminders; recurrence exceptions; local-only calendars; all-day/DST handling |
| Fossify Contacts | github.com/FossifyOrg/Contacts | GPL-3.0 | contact field surface; vCard import/export expectations |
| Fossify Notes | github.com/FossifyOrg/Notes | GPL-3.0 | text vs checklist note types; editor undo/redo; per-note lock |
| Fossify Clock | github.com/FossifyOrg/Clock | GPL-3.0 | alarm config surface; reschedule-after-reboot requirement |
| Fossify Messages | github.com/FossifyOrg/Messages | GPL-3.0 | threaded message store; soft-delete/recycle-bin; search result modeling |
| Fossify commons | github.com/FossifyOrg/commons | GPL-3.0 | shared-concern patterns (app lock, two-tier config, interval picker, conflict UX) |
| Etar Calendar | github.com/Etar-Group/Etar-Calendar | GPL-3.0 | AOSP-style RRULE parse + human-readable formatting; ORGANIZER/ATTENDEE modeling; ICS round-trip |
| Tasks.org | github.com/tasks/tasks | GPL-3.0 | VTODO subtasks via RELATED-TO; repeat-after-completion; named CalDAV properties |
| Thunderbird (desktop) | MPL-2.0 | MPL-2.0 | autoconfig/ISPDB account discovery; CONDSTORE/QRESYNC incremental IMAP sync; **M365 OAuth XOAUTH2 + project-owned public client-ID pattern** |
| K-9 / Thunderbird for Android | github.com/thunderbird/thunderbird-android | Apache-2.0 | mail backend abstraction; demo/testing backend pattern; per-folder sync window + lazy fetch; autodiscovery; **embedded public client ID for M365/Gmail OAuth** |
| DavMail Gateway | github.com/mguessan/davmail | GPL-2.0 | model for bridging Exchange/O365 (EWS/Graph) to IMAP/SMTP/CalDAV/CardDAV; O365 device-code/interactive OAuth modes — recommended to users as an **external companion, never bundled** |

Notes:
- GPL references are **read-only inspiration / external companions**; their code is never
  copied or linked into `courrier` (AGPL-3.0-only, or commercially licensed). See LICENSING.md.
- MPL references inform design only; the only MPL component **shipped** is the `enough_mail`
  dependency, recorded in NOTICE.
- K-9 / Thunderbird-Android is Apache-2.0 (compatible); clean-room reimplementation was
  still preferred (Kotlin→Dart).
- The **Microsoft 365 OAuth approach** (public-client + PKCE, embedded project-owned client
  ID, IMAP/SMTP XOAUTH2) was informed by Thunderbird/K-9 practice; `courrier` registers its
  **own** Entra app and does not reuse any third-party client ID.

Maintainer: keep this file updated whenever a new reference is consulted.

- clock 1.1.3: https://pub.dev/packages/clock/versions/1.1.3

- cross_file 0.3.5+5: https://pub.dev/packages/cross_file/versions/0.3.5+5

- file_selector 1.1.0: https://pub.dev/packages/file_selector/versions/1.1.0

- file_selector_android 0.5.2+11: https://pub.dev/packages/file_selector_android/versions/0.5.2+11

- file_selector_ios 0.5.3+7: https://pub.dev/packages/file_selector_ios/versions/0.5.3+7

- file_selector_linux 0.9.4+1: https://pub.dev/packages/file_selector_linux/versions/0.9.4+1

- file_selector_macos 0.9.5+2: https://pub.dev/packages/file_selector_macos/versions/0.9.5+2

- file_selector_platform_interface 2.7.0: https://pub.dev/packages/file_selector_platform_interface/versions/2.7.0

- file_selector_web 0.9.5: https://pub.dev/packages/file_selector_web/versions/0.9.5

- file_selector_windows 0.9.3+6: https://pub.dev/packages/file_selector_windows/versions/0.9.3+6

- stack_trace 1.12.2: https://pub.dev/packages/stack_trace/versions/1.12.2
