# BUILD_PROMPT.md — `courrier` (consolidated v2, with Microsoft 365)

> The authoritative build plan. Read CLAUDE.md and AUDIT_LOOP.md first. Every milestone
> ends with the audit loop (AUDIT_LOOP.md) and a **HARD STOP** for human approval.
> Reason-first iteration and the zero-warning policy apply throughout. All refinements from
> the Fossify, Etar, Tasks.org, K-9/Thunderbird studies and the Microsoft 365 research are
> folded in below.

---

## Architecture (target)
```
lib/
  core/
    theme/       # tokens; #28a745; Auto/Light/Dark; the ONLY place hex colors live
    db/          # drift/SQLite — offline source of truth for all modules
    net/         # DAV client + named CalDAV/CardDAV properties; REST clients; error model
    sync/        # connection mgr, account orchestration (incl. local-only accounts)
    auth/        # OAuth2 (flutter_appauth, PKCE) providers + token store/refresh
    config/      # two-tier: secrets/tokens (secure_storage) vs preferences (settings)
    lock/        # app lock (PIN/biometric)
    widgets/     # shared controls incl. CustomIntervalPicker, conflict/rename dialogs
  modules/
    mail/        # MailBackend interface; IMAP impl (enough_mail); demo backend; offline store
      providers/ # OPTIONAL module: Gmail + Microsoft 365 (IMAP/SMTP XOAUTH2). Keeps core F-Droid-clean.
    calendar/    # VEVENT; rrule parse + human-readable formatter; EXDATE/RECURRENCE-ID
    contacts/    # CardDAV VCARD
    tasks/       # VTODO; subtasks via RELATED-TO; fixed + repeat-after-completion recurrence
    reminders/   # local notifications + VALARM; re-arm on reboot/upgrade
    notes/       # Nextcloud Notes REST; text + checklist; editor undo/redo
    feeds/       # RSS/Atom; News API + bundled parser
  shell/         # unified nav, onboarding (autoconfig + OAuth), settings, search, About
```
Calendar + Tasks share **one synced collection layer** (VEVENT/VTODO side by side) with
**two UI presentations**. Mail auth is **token-capable** (password AND OAuth2/XOAUTH2)
from M6 so M365/Gmail are account types, not a separate protocol stack.

---

## M0 — Scaffold, licensing posture, theme, shell
> **Read PREFLIGHT.md first.** Apply its **locked decisions** verbatim: bundle ID /
> Android `applicationId` `dev.etabli.courrier`, iOS 13.0, Android `minSdk` 24, OAuth
> redirect scheme `dev.etabli.courrier://oauth`, **Gmail deferred (M365-only v1)**. Gates
> from M2 onward assume PREFLIGHT's live services (Nextcloud/IMAP/M365 + Entra app) exist.
- Scaffolding: `LICENSE` (Apache-2.0), `NOTICE` (incl. MPL `enough_mail` + OAuth deps — see
  LICENSING.md), `THIRD_PARTY_REFERENCES.md`, `CONTRIBUTING.md` (inbound=outbound + DCO),
  `.github/workflows/license-gate.yml`, **`.gitignore`** (must ignore `secrets.json`),
  **`secrets.example.json`**, strict `analysis_options.yaml`, `FUNDING.yml`.
- Apply the locked decisions to iOS/Android project config (bundle IDs, min OS, URL scheme).
- `core/config` reads runtime/test config via `String.fromEnvironment` fed by
  `--dart-define-from-file=secrets.json`; the M365 **client ID is public** config, while
  test passwords live only in the gitignored `secrets.json`.
- Add `courrier` to `apps.json` and run the icon generator (geometric folded-letter/desk
  glyph — no brushstroke) so the asset catalogs exist.
- `core/theme` tokens + Auto/Light/Dark from one source.
- App shell: unified navigation across seven modules (empty screens ok), Coder/Hugo.
- README + BUILD_LOG: clean-room note (Fossify/Etar/Tasks/DavMail consulted, no code copied)
  and the deliberate divergences (no color customization, no freemium, no system-PIM
  dependency).
- **Gate:** audit dims 1, 5, 8; no hex outside theme; license gate green; `secrets.json`
  not tracked by git. STOP.

## M1 — Local DB + sync engine skeleton + config tiers
- `core/db` drift schema for all modules. **N reminders per event**; distinct **UID** and
  **etag** columns; `account_id`/`collection_id` so **local-only accounts** are first-class.
- `core/config` two-tier: secrets **and OAuth tokens** → `flutter_secure_storage`;
  preferences → one central settings store.
- `core/sync` connection manager + account orchestration; `core/net` error model.
- Conflict policy defined **with a UI contract**: server-wins on pull, last-write-wins on
  push, surfaced conflicts get a resolution dialog.
- **Gate:** migration tests green; audit dims 1,2,5,6. STOP.

## M2 — DAV layer (CalDAV/CardDAV foundation)  ⚠ highest-risk milestone
- Discovery: `.well-known/{caldav,carddav}`, `current-user-principal`,
  `calendar-home-set`, `addressbook-home-set`.
- Enumeration via `PROPFIND` modelling **named properties**: `displayname`, `getctag`,
  `sync-token`, `supported-calendar-component-set`, `calendar-color`, Apple `calendar-order`.
- Efficient sync: `sync-collection` REPORT (sync-token) with ctag/etag fallback;
  `calendar-multiget`/`addressbook-multiget`. Writes: `PUT` with `If-Match`/`If-None-Match`;
  `DELETE` with etag guard; surface 412.
- **iCalendar + vCard (de)serialize is THE risk** (Dart's iCal ecosystem is weaker than
  ical4j). Round-trips MUST **preserve unknown properties**; preserve `ORGANIZER`,
  `ATTENDEE`, `EXDATE`, `RECURRENCE-ID`, `RELATED-TO`. Vet a package hard or hand-roll a
  tested RFC 5545/6350 subset. Tests vs recorded responses (happy + 412 + token-reset +
  unknown-prop preservation).
- Build this layer **Nuage-reusable** (clean boundary, no `courrier` leakage).
- **Gate:** DAV + round-trip tests green; audit dims 1,2,5,7. STOP.

## M3 — Calendar (VEVENT)
- Agenda + month views; create/edit/delete; **recurrence read + delete-occurrence**
  (this / this-and-following / all) with EXDATE/RECURRENCE-ID; all-day + DST handling.
- Recurrence via **`rrule`**: parse **and human-readable formatter**.
- **Multiple reminders** per event; **ORGANIZER + ATTENDEE** displayed and round-tripped.
- ICS import; offline-first; two-way sync via M2. Vignette: Calendar.
- **Gate:** create→sync→reload round-trip on a live calendar; all-day/DST tests; audit 1–8. STOP.

## M4 — Contacts (VCARD)
- List + detail + create/edit/delete; photo handling; groups; offline-first; sync via M2;
  round-trip preserves unknown vCard props. Vignette: Contacts.
- **Gate:** round-trip verified; audit 1–8. STOP.

## M5 — Tasks (VTODO) + Reminders
- Tasks via the shared collection layer. **Subtasks via `RELATED-TO;RELTYPE=PARENT`.**
  Support **both** fixed-schedule recurrence **and repeat-after-completion**.
- Reminders: `flutter_local_notifications` from VALARM + due dates; permission flow;
  vibrate/sound/label/one-shot; weekday recurrence. **Re-arm after reboot and after app
  upgrade** (Android `RECEIVE_BOOT_COMPLETED`; iOS re-schedule on launch).
- Vignettes: Tasks, Reminders.
- **Gate:** recurring task + subtask + alarm syncs and re-arms after simulated reboot;
  audit 1–8. STOP.

## M6 — Mail: token-capable backend, store, read path
- Define a **`MailBackend` interface** that supports **both password and OAuth2 bearer
  (XOAUTH2/OAUTHBEARER)** auth. Implement with `enough_mail` (IMAP). Build an **in-memory
  demo backend** seeded with sample mail (feeds M13 screenshots + M14 sample content).
- Offline store: folders incl. special-use, envelopes, flags, bodies, attachment metadata.
  **Mail sync policy:** bounded per-folder window; headers + small bodies eager, large
  bodies/attachments lazy.
- Threading (References/In-Reply-To + subject fallback). MIME-to-widget render (plain +
  sanitized HTML; **remote images off by default**, per-message reveal).
- **Soft-delete → Trash with restore** (Recycle Bin); explicit **Archive**; EXPUNGE only on
  empty-trash. **Local-first search** with snippet highlighting. Vignette: Mail (started).
- **Gate:** inbox syncs offline via real + demo backends; threads render; no remote content
  executes; audit 1–8. STOP.

## M7 — Mail: compose/send, autodiscovery, push
- SMTP send; attachments; reply/forward preserving quoting; Drafts.
- **Autoconfig onboarding:** Mozilla ISPDB + `.well-known/autoconfig` + DNS SRV; supplement
  `enough_mail`'s `Discover`. Autodiscovery test fixture.
- Push/refresh: IMAP **IDLE** foreground; documented background-fetch strategy (iOS limits);
  **CONDSTORE/QRESYNC** incremental sync where advertised, UID-diff fallback.
- Vignette: Mail (completed).
- **Gate:** send+receive+IDLE on a live account; autodiscovery resolves a known domain;
  audit 1–8. STOP.

## M8 — Mail: OAuth2 provider — Microsoft 365 via IMAP/SMTP XOAUTH2 (Gmail seam deferred)  ← Exchange/M365
> Microsoft killed Basic Auth for legacy protocols (Oct 1 2022) and SMTP AUTH (≈Sept 2025),
> so M365 mail **requires OAuth 2.0**. IMAP/SMTP remain available under XOAUTH2 — so this is
> an **auth** addition reusing the M6/M7 IMAP stack, **not** a new protocol. **Verify the
> Microsoft dates/availability against the Exchange Team blog + M365 Message Center before
> relying** (they shift).

- `core/auth`: OAuth via **`flutter_appauth`** (authorization-code + **PKCE**, **no client
  secret**); system-browser redirect; refresh tokens in `flutter_secure_storage`; silent
  refresh; feed access token to `enough_mail` **XOAUTH2**.
- **Providers (in the OPTIONAL `mail/providers/` module):**
  - **Microsoft 365 / Exchange Online (v1 provider)** — host `outlook.office365.com:993` /
    `smtp.office365.com:587`; authority `login.microsoftonline.com/common` (or
    `/organizations`); scopes `offline_access`,
    `https://outlook.office.com/IMAP.AccessAsUser.All`,
    `https://outlook.office.com/SMTP.Send`; redirect `dev.etabli.courrier://oauth`
    (from PREFLIGHT locked decisions).
  - **Gmail — seam only, DEFERRED to v2.** Scaffold the provider behind the interface but
    **disabled in v1**: Google restricted-scope (`https://mail.google.com/`) requires a
    CASA security assessment that is out of scope for v0.1.0. Keep the seam, ship M365 only.
- **Registration:** ONE project-level **Entra public-client** app (no secret); embed the
  client ID (public is fine); configure iOS/Android redirect URIs; pursue **publisher
  verification** to cut consent friction. End users register nothing.
- **Tenant friction is first-class UX, not a crash:** model and render clear, actionable
  states for *admin-consent-required*, *app blocked by tenant policy*, *IMAP/SMTP disabled
  by admin*, *SMTP AUTH disabled for mailbox*.
- **F-Droid hygiene:** keep all of this in the optional module; do **NOT** use `msal_auth`
  or any proprietary native MSAL wrapper. The M365 connection earns the **NonFreeNet**
  anti-feature tag (allowed); modularity contains it.
- Vignette: Connecting Microsoft 365 (note Gmail as a deferred v2 provider).
- **Gate:** a live M365 mailbox connects via XOAUTH2, sends+receives, token refreshes after
  expiry; tenant-consent error states render; demo backend still green; audit dims 1–8 +
  license-gate (no banned pkg) + F-Droid modularity check. STOP.

## M9 — Notes (Nextcloud Notes REST)
- List/edit/create/delete; **text and checklist** notes (checklist ↔ markdown task lists);
  **editor undo/redo**; optional per-note lock (rides core/lock); offline-first; 1:1 note-
  file round-trip. Vignette: Notes.
- **Gate:** round-trip incl. checklist; audit 1–8. STOP.

## M10 — RSS / feeds
- Subscribe/list/read; Nextcloud **News API** primary; **bundled** standalone parser
  fallback for direct feeds; mark-read sync where News API present; offline reading; refresh
  interval uses the shared **CustomIntervalPicker**. Vignette: Feeds.
- **Gate:** News-API feed and direct feed both read offline; audit 1–8. STOP.

## M11 — Unified shell polish
- Global search across modules; unified settings; **app lock (PIN/biometric)**; **settings
  export/import**; **What's-New** dialog post-update; **sync-conflict resolution UI**;
  onboarding deriving CalDAV/CardDAV/Notes/News (+ mail autoconfig + **OAuth providers**)
  from one entry; About with funding split (BMC on store flavor, Liberapay on F-Droid/GH).
  Vignette: Settings & onboarding.
- **Gate:** cold-start onboarding to a working multi-module account incl. an M365 mail
  account; app lock works; audit 1–9. STOP.

## M12 — Global stability pass
- Run the **global pre-release audit** (AUDIT_LOOP.md §6): all 10 dimensions, whole app,
  cap 10. Drive every finding to zero; profile-mode jank check on all primary flows.
- **Gate:** converged clean within cap. STOP.

## M13 — Screenshot harness (Maestro)
- Maestro flows driving each module (incl. **demo mail backend**) into representative
  states; exhaustive light+dark capture.
- **Gate:** harness green, full gallery produced; audit 1,3,8,10. STOP.

## M14 — Vignettes (tutorial-grade) + bundled sample content
- `docs/` vignettes: TOC, per-feature step sequences, sample code, embedded M13 gallery,
  and a **"Connecting Microsoft 365"** + **"Using DavMail for on-prem Exchange / Exchange
  calendar+contacts as CalDAV/CardDAV"** how-to.
- Ship **bundled runnable sample content**: demo mail (demo backend), sample notes/feeds,
  optional **holiday ICS** as local-only calendars — explorable offline on first run.
- **Gate:** docs render; sample content loads on fresh install; audit 1,2,10. STOP.

## M15 — Privacy, store/F-Droid metadata, funding, RELEASE GATE
- `ios/PrivacyInfo.xcprivacy`; Fastlane F-Droid metadata **(declare NonFreeNet for the M365
  module)**; funding surfaces flavor-aware; `NOTICE` final (every shipped dep + MPL entry +
  OAuth deps); split-per-ABI APK CI.
- Final **global pre-release audit** (cap 10) + license gate green.
- **Gate:** converged clean → cut **GitHub Release v0.1.0**. Do not tag before this is
  clean. STOP with the release summary.

---

## Beyond v0.1.0 — planned (do NOT build in this cycle)
- **Microsoft Graph backend (v2).** Unify Exchange **mail + calendar + contacts** behind the
  `MailBackend` / DAV-equivalent boundaries via Graph REST (hand-rolled client + existing
  `core/auth`). Strategic, and required before **EWS retires in Exchange Online (~Oct 1
  2026 — verify)**. IMAP-XOAUTH2 (M8) is the v1 bridge; Graph is the durable home and the
  only path to Exchange calendar/contacts natively.
- **DavMail companion (documented, never bundled).** GPLv2 external gateway for **on-prem
  Exchange** and for surfacing **Exchange calendar/contacts as CalDAV/CardDAV** (which
  `courrier` already speaks). Document setup in M14; never ship in-binary.

## Definition of done (v0.1.0)
Seven modules functional and offline-first against a live Nextcloud · **M365 mail account
via OAuth2 XOAUTH2** works incl. token refresh + tenant-error UX · analyze clean, tests
green, zero audit findings · no hardcoded colors, Auto/Light/Dark correct · Apache-2.0 held,
NOTICE correct incl. MPL + OAuth deps, license gate green, no banned pkg, M365 module
modular (NonFreeNet declared), privacy manifest present, no telemetry · Maestro gallery +
tutorial-grade vignettes (incl. M365 + DavMail how-tos) + bundled sample content · funding
correct per flavor · GitHub Release v0.1.0 from a converged M15.

**Begin with M0. Do not pass any STOP without explicit approval. Maintain BUILD_LOG.md.**
