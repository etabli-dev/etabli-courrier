# CLAUDE.md — `courrier`

> Claude Code reads this file automatically at the start of every session.
> It is the standing contract. Read the indexed files before acting.

## What `courrier` is
A privacy-first, **offline-first** FOSS alternative to the Outlook mobile app, in a single
**Flutter** binary: **email, calendar, contacts, tasks, reminders, notes, RSS** — syncing to
self-hosted **Nextcloud**, with **Microsoft 365 / Exchange Online mail** as a first-class
account type. Member of the **Établi Suite** (`etabli-dev`). Paid-upfront, **no IAP**.
Ships to App Store, Google Play, F-Droid, GitHub Releases.

## File index (read in this order)
1. **CLAUDE.md** (this file) — standing rules.
2. **PREFLIGHT.md** — provision test services + the project's Entra app + **LOCKED build
   decisions**. **Satisfy before M0.**
3. **BUILD_PROMPT.md** — the authoritative milestone plan M0–M15. The work.
4. **AUDIT_LOOP.md** — the multi-round audit→refine engine run at every gate.
5. **LICENSING.md** — how the Apache-2.0 posture is kept; dependency allow-list; M365/F-Droid.
6. **THIRD_PARTY_REFERENCES.md** — clean-room provenance (GPL/MPL refs consulted).
7. **NOTICE**, **CONTRIBUTING.md**, **.github/workflows/license-gate.yml**, **.gitignore**,
   **secrets.example.json** — droppable artifacts.
8. **BUILD_LOG.md** — the running log you maintain. Not optional.

## Locked stack (do not deviate without STOPPING to ask)
Flutter/Dart · `enough_mail` (MPL-2.0) for IMAP/SMTP/MIME incl. **XOAUTH2** ·
`flutter_appauth` (auth-code + PKCE, no secret) for the **Microsoft 365** mail OAuth
provider (Gmail seam scaffolded but **deferred to v2** — Google CASA burden) · `drift`/SQLite offline store · custom DAV layer for CalDAV/CardDAV · `rrule` for
recurrence · Nextcloud Notes REST · Nextcloud News API + bundled feed parser ·
`flutter_secure_storage` for secrets/tokens · `flutter_local_notifications` for reminders ·
Maestro for screenshots · GitHub Actions CI.
**Forbidden:** `msal_auth` or any wrapper of Microsoft's proprietary native MSAL binaries
(breaks F-Droid). **Graph is v2, not v0.1.0.** **DavMail (GPLv2) is documented, never bundled.**
Test credentials are injected at run via `--dart-define-from-file=secrets.json` (gitignored);
the M365 **client ID is public** config. **Locked build decisions live in PREFLIGHT.md.**

## Operating principles (NON-NEGOTIABLE)
1. **Reason-first iteration.** Before ANY fix, write: Hypothesis → Strategy → Verification
   plan → Fallback. No fix before those four exist. No exceptions for "obvious" fixes.
2. **Zero-warning hard-fail.** Any error, warning, analyzer info, deprecation, framework
   assertion, overflow/key warning, dropped frame, or skipped/failing test is a **hard
   fail** requiring a documented fix loop — never a `// TODO`, never a suppression.
3. **Build-verify gating with HARD STOPS.** After every milestone, run the audit loop
   (AUDIT_LOOP.md). It must converge clean. Then **STOP and wait for human approval**
   before the next milestone. Never continue autonomously past a STOP.
4. **Bundled over fetched.** Anything needed at first launch ships bundled.
5. **Offline-first.** Every module reads/writes the local DB first; sync is idempotent;
   conflicts surface in UI, not just logs.
6. **Over-document.** Add a feature → add its vignette section in the same milestone.

## Licensing posture (summary — full detail in LICENSING.md)
- `courrier` is **Apache-2.0** and must stay so. Copyleft attaches to *shipped code*, not
  to *learning*. **No GPL/AGPL code is ever linked or copied.**
- GPL refs (Fossify, Etar, Tasks.org, **DavMail**) are **read-only inspiration / external
  companions** → clean-room reimplement; never bundle.
- MPL refs/deps (`enough_mail`, Thunderbird) ship as **per-file** copyleft → keep their
  files MPL, record in NOTICE, don't transcribe into Apache files.
- K-9 / Thunderbird-Android is **Apache-2.0** → compatible; clean-room still preferred.
- **Microsoft 365:** one **project-level Entra public-client** registration (no secret,
  PKCE); the embedded client ID is public and fine; end users register nothing. The M365
  module triggers F-Droid's **NonFreeNet** anti-feature (allowed) — keep it **modular** so
  the core stays clean. A CI license gate fails the build on any RED license or banned pkg.

## Aesthetic (Coder/Hugo — enforced by audit)
Minimal, whitespace-heavy, monospaced. **Single green accent `#28a745`.** Borders over
shadows. Auto/Light/Dark from one centralized token source. **No hardcoded colors anywhere**
(grep gate). No arbitrary color customization (Fossify's identity, not ours). No
freemium/feature-locking (we are paid-upfront).

## Begin
**Before M0:** confirm PREFLIGHT.md is satisfied — test Nextcloud/IMAP/M365 services, the
project's Entra public-client app, the locked build decisions, and `secrets.json`
(gitignored, consumed via `--dart-define-from-file`).
Start at **M0** in BUILD_PROMPT.md. Maintain BUILD_LOG.md throughout. Do not pass any STOP
without explicit approval.
