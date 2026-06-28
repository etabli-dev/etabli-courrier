# Using DavMail as an external companion

`courrier` does not bundle DavMail. DavMail is **GPLv2** and the
project's licensing posture forbids linking any GPL/AGPL code (see
`LICENSING.md`). DavMail is, however, an excellent **external
companion** for two common situations courrier on its own can't address:

- Connecting to **on-premise Exchange** (where IMAP/SMTP may be locked
  down but EWS / MAPI is exposed).
- Surfacing **Exchange calendar + contacts** to `courrier` as CalDAV +
  CardDAV — which `courrier` already speaks natively.

This page is the recommended setup. Run DavMail on a machine you trust
(typically the user's own desktop or a home server), point `courrier` at
DavMail's local addresses, and the M3/M4 modules just work.

## When to reach for DavMail

| symptom                                                                  | reach for                                                |
|--------------------------------------------------------------------------|----------------------------------------------------------|
| Exchange Online mailbox, OAuth available                                  | M8 native — use `courrier`'s Microsoft 365 provider       |
| Exchange Online mailbox, OAuth blocked by tenant policy                   | DavMail (delegated EWS / Graph) → IMAP / SMTP to courrier |
| On-prem Exchange (EWS exposed, IMAP off)                                  | DavMail → IMAP / SMTP to courrier                         |
| Need calendar + contacts from Exchange (Online or on-prem) on a phone     | DavMail's CalDAV / CardDAV bridge → M3 / M4 in courrier   |

## Installing DavMail

1. Download the latest release from [davmail.sourceforge.io](https://davmail.sourceforge.io).
   Choose the platform package: Windows installer, macOS DMG, Linux
   tarball, or the Docker image at `mguessan/davmail`.
2. Launch DavMail. The first run opens the settings dialog.
3. Set the **Exchange server URL**. For Exchange Online:
   `https://outlook.office365.com/EWS/Exchange.asmx` (or the Graph
   endpoint if you've moved to Graph; DavMail still supports it).
   For on-prem: paste the EWS URL your IT department provides.
4. Pick the **authentication mode** that matches your tenant:
   - **O365 device-code** if MFA / interactive sign-in is required.
   - **OAuth interactive** if your tenant allows a browser-based flow.
   - **Basic** only if you're on a legacy on-prem deployment.
5. Open the **Ports** tab. The defaults DavMail listens on:
   - `localhost:1143` — IMAP
   - `localhost:1025` — SMTP
   - `localhost:1080` — CalDAV
   - `localhost:1080` — CardDAV (same port; DavMail discriminates by URL)
6. Tick "Bind to all interfaces" only if you actually need other
   devices on your network to reach DavMail. Most users keep it
   loopback-only and run DavMail on the same machine as courrier (e.g.
   a home server) reaching it over a VPN.

## Connecting courrier to DavMail

### Mail (IMAP + SMTP)

From `courrier` Settings → Accounts → Add IMAP account, enter:

- **Server**: `localhost` (or the IP/hostname where DavMail runs)
- **IMAP port**: `1143`, no TLS
- **SMTP port**: `1025`, no TLS
- **Username**: your Exchange `user@example.org` address
- **Password**: your Exchange password (or "any" if DavMail's
  device-code/OAuth flow is what authenticates you upstream)

### Calendar (CalDAV) + Contacts (CardDAV)

From `courrier` Settings → Accounts → Add Nextcloud account, enter:

- **Base URL**: `http://localhost:1080`
- **Username**: your Exchange address
- **Password**: same as above

The M2 discovery layer (`DavDiscovery`) walks the standard
`.well-known/caldav` + principal + home-set chain. DavMail responds the
way Nextcloud does, so the M3 calendar + M4 contacts modules pick up
the discovered collections automatically.

## What you give up vs. M8 native M365

- The M11 onboarding screen has no first-class "DavMail" entry — you
  set DavMail up first, then point courrier at it via the regular
  IMAP / Nextcloud account flows above.
- DavMail's process needs to be running whenever courrier syncs. Put
  it in `launchd` / `systemd` / Windows Services so it survives
  reboots.
- DavMail is GPLv2, so you maintain it; courrier never bundles it.

## What you gain

- Works for tenants where the modern OAuth flow is administratively
  blocked.
- Brings Exchange calendar + contacts onto courrier's existing M3 + M4
  CalDAV/CardDAV stack — no new module needed in courrier itself.
- Decouples the proprietary-service surface from the binary on your
  device: DavMail lives on your server, courrier stays clean for the
  F-Droid `NonFreeNet` posture.

## Open / further reading

- DavMail's project README covers per-platform service install (launchd,
  systemd, Windows Service).
- M3's vignette covers the calendar UI; M4's vignette covers contacts.
  Once DavMail is reachable, both modules behave the same as they would
  against a Nextcloud server.
- Microsoft Graph is the planned **v2** path for native Exchange
  calendar / contacts inside courrier (see BUILD_PROMPT.md "Beyond
  v0.1.0"). DavMail is the recommended bridge until then.
