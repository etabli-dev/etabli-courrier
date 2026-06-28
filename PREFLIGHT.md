# PREFLIGHT.md — provision before launching the Claude Code session

> Satisfy this **before M0**. The agent scaffolds code on its own, but several milestone
> *gates* need live services and a few items have real lead time. This file is the **single
> source of truth for the locked build decisions** — the other stack files reference it.

---

## 1. Locked build decisions (change them HERE; other files defer to this)

| Decision | Value | Note |
|---|---|---|
| Bundle ID (iOS) / `applicationId` (Android) | `dev.etabli.courrier` | Use a reverse-DNS domain you actually control; change if `etabli.dev` isn't yours. |
| Min iOS | `13.0` | Floor for `flutter_appauth` / secure storage. |
| Android `minSdk` | `24` (Android 7.0) | Safe modern floor (~98%+); `targetSdk` = current. |
| OAuth redirect scheme | `dev.etabli.courrier://oauth` | Custom-scheme redirect (AppAuth). Register it in Entra. |
| v1 mail OAuth provider | **Microsoft 365 only** | **Gmail deferred to v2** — Google restricted-scope CASA assessment is out of scope for v0.1.0. |
| Secrets injection | `--dart-define-from-file=secrets.json` | `secrets.json` is gitignored; M365 client ID is public config. |

---

## 2. Blocking prerequisites (must exist before the named gate)

| Provision | Unblocks | What to set up |
|---|---|---|
| **Nextcloud test instance** | M2, M3, M4, M5, M9, M10 | A user + **app-password**; enable the **Calendar, Contacts, Notes, News** apps; seed a couple of events/contacts/notes/feeds. Self-hosted or throwaway. |
| **IMAP/SMTP test mailbox** | M6, M7 | Any standard account (host/user/password). |
| **Microsoft 365 dev tenant + mailbox** | M8 | Free **Microsoft 365 Developer Program** sandbox (E5). Admin must **enable IMAP & SMTP** and **SMTP AUTH per-mailbox** (off by default on modern tenants). |
| **Entra app registration** | M8 | **You** create it (the agent can't): *Public client*, **no secret**, **PKCE**; add iOS + Android **redirect URIs** for `dev.etabli.courrier://oauth`; delegated scopes `offline_access`, `IMAP.AccessAsUser.All`, `SMTP.Send`; record the **client ID**. |

> The agent should treat a missing prerequisite at a gate as a **STOP-and-ask**, not a
> workaround. Provisioning these up front prevents that.

---

## 3. Long lead time — start now, needed later

- **Apple Developer Program** ($99/yr) + **Google Play** ($25 once) — enrollment + first
  review have delays; **M15** needs them.
- **Entra publisher verification** — needs a Microsoft Partner account + domain verification;
  removes the scary "unverified app" consent prompt in managed tenants. **Weeks.**
- **Privacy policy URL** — App Store requires it; host on the suite site.
- **(If Gmail is ever un-deferred)** Google **CASA** security assessment for the
  `mail.google.com` restricted scope — onerous and slow. This is *why* Gmail is v2.

---

## 4. Secrets handling (wired into the build)

`courrier` reads runtime/test config via `String.fromEnvironment(...)`, fed at run time by
`--dart-define-from-file`. **No test password is ever committed.**

1. Copy the template → real file (the real file is gitignored):
   ```
   cp secrets.example.json secrets.json
   ```
2. Fill in your own test values in `secrets.json`.
3. Run / build with it:
   ```
   flutter run   --dart-define-from-file=secrets.json
   flutter test  --dart-define-from-file=secrets.json
   flutter build apk --debug --dart-define-from-file=secrets.json
   ```
4. In code, read keys like:
   ```dart
   const ncBaseUrl = String.fromEnvironment('NEXTCLOUD_BASE_URL');
   const m365ClientId = String.fromEnvironment('M365_CLIENT_ID'); // public — fine
   ```

- The **M365 client ID is public** and may live in config/source.
- **Test passwords / app-passwords are NOT** — they stay only in `secrets.json`.
- The CI license gate fails the build if `secrets.json` is ever tracked by git.

---

## 5. Toolchain checklist (agent's environment)

- [ ] Flutter **stable** channel + Dart.
- [ ] **Xcode** (iOS build) and **Android SDK** + an emulator/AVD.
- [ ] **Maestro CLI** (screenshot harness, M13).
- [ ] **Claude Code** itself.
- [ ] Network reach from the agent's environment to your **Nextcloud** and **M365** test
      endpoints; emulator access for runtime audit dimensions.
- [ ] `very_good_cli` pinned (or use the `pubspec.lock` + jq fallback in the license-gate
      workflow) — confirm its license-check flag names before relying on the gate.

---

## 6. Repo setup

- Create `courrier` under the **`etabli-dev`** org.
- Drop the stack files at the repo root; keep `.github/workflows/license-gate.yml` at its
  path. Ensure `.gitignore` and `secrets.example.json` are committed; **`secrets.json` is
  not**.
- Add a `courrier` entry to **`apps.json`** and run the icon generator (geometric
  folded-letter/desk glyph — **no brushstroke**, per the suite rule) so M0 has the iOS/
  Android asset catalogs.

---

## 7. Who does what

**You (before launch):** services in §2, Entra app in §2, long-lead enrollments in §3,
`secrets.json` from §4, repo in §6, confirm §1 values.
**The agent (from M0):** all scaffolding, code, theme, modules, the audit loop, docs,
screenshots — stopping at any gate whose §2 prerequisite is missing.

### Minimum to start today
Nextcloud instance · one IMAP mailbox · M365 sandbox · Entra registration · the six §1
locked decisions · `secrets.json`. Everything else can trail the milestone that needs it.
