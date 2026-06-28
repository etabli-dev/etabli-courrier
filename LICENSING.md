# LICENSING.md — keeping `courrier` Apache-2.0

> Standing reference. Not legal advice; the rules below are well-settled practice.
> The whole strategy rests on one fact: **copyleft attaches to shipped code, not to
> learning.** Keep copyleft code out of the binary and Apache-2.0 holds.

## The principle
- **Reference ≠ dependency.** Reading GPL/MPL code to learn *what a feature must do* does
  not bind `courrier`. **Linking or copying** code does. Only what ships constrains us.
- Therefore: **no GPL/AGPL code is ever copied or linked.** MPL is allowed as per-file
  copyleft. Apache/MIT/BSD link freely.

## Dependency allow-list (enforced by CI — see `.github/workflows/license-gate.yml`)
- **GREEN (link freely):** Apache-2.0, MIT, BSD-2-Clause, BSD-3-Clause, ISC, Zlib, Unlicense, CC0.
- **YELLOW (allowed; obligations below):** MPL-2.0, EPL-2.0, CDDL-1.x.
- **RED (build fails):** GPL-2.0, GPL-3.0, AGPL-3.0, **LGPL-* ** (static Flutter linking
  makes LGPL effectively viral — treat as red), SSPL, BUSL, "no-license".
- **BANNED packages (regardless of their wrapper's license):** `msal_auth` and any wrapper
  of Microsoft's **proprietary native MSAL** binaries — they inject a non-free dependency
  that **breaks F-Droid**.
- Applies to **direct and transitive** packages. New license not on the list → **STOP**, do
  not add the dep, ask.

### OAuth dependencies (all GREEN — verify SPDX at pin time, record in NOTICE)
- **`flutter_appauth`** — wraps the open-source AppAuth SDKs (Apache-2.0 upstream); the Dart
  package is permissively licensed. **Preferred** OAuth flow lib.
- **`aad_oauth`** — Dart/Flutter Azure AD OAuth (webview), permissive. Acceptable alternative.
- **`oauth2`** (Dart team) — BSD-3-Clause building blocks.

## Clean-room rules for GPL references (Fossify, Etar, Tasks.org, DavMail)
- Work from the **abstracted requirements** (the addenda / vignettes), not open source files
  side-by-side.
- Do **not** copy code, comments, distinctive identifiers, or transcribe non-obvious
  algorithms. Field lists, protocol behaviors, and UX flows are facts you may reimplement;
  specific code expression is not.
- Keep `THIRD_PARTY_REFERENCES.md` current as provenance.

## MPL dependencies (`enough_mail`; Thunderbird as reference)
- **Unmodified dependency:** keep its files MPL-2.0; add a NOTICE entry with a source link.
  That is the entire obligation. MPL is **per-file** — it does not infect Apache code.
- **If ever modified:** the modified files stay MPL-2.0 and that source must be published;
  the rest stays Apache-2.0. **Prefer upstream over forking.** Never paste MPL into an
  Apache-licensed file.

## K-9 / Thunderbird-Android
- **Apache-2.0** — compatible. Clean-room still preferred (Kotlin→Dart). If a small utility
  were ever adapted, Apache-2.0 permits it **with attribution** (record in NOTICE).

## Microsoft 365 / Exchange Online integration
- **OAuth is mandatory** (Basic Auth retired for legacy protocols Oct 1 2022, SMTP AUTH
  ≈Sept 2025 — verify against Microsoft sources). v1 uses **IMAP/SMTP XOAUTH2** via
  `enough_mail` + `flutter_appauth`.
- **App registration:** one **project-level Entra public-client** app, **no client secret**,
  **PKCE**. The **embedded client ID is public and acceptable** (security comes from PKCE +
  redirect-URI restrictions, not ID secrecy) — this is the same pattern Thunderbird/K-9 use.
  **End users register nothing.** Pursue **publisher verification** to reduce consent
  friction / "unverified app" warnings in managed tenants.
- **Do NOT reuse another project's client ID** (e.g., Thunderbird's) — fragile and against
  their terms. Register your own.
- **Microsoft API Terms:** embedding a public client ID and calling Outlook/IMAP/Graph is
  permitted; comply with throttling, branding, and acceptable-use rules.
- **F-Droid:** connecting to a proprietary network service is **allowed** but earns the
  **`NonFreeNet`** anti-feature label (informational, non-blocking). Keep all M365/OAuth code
  in the **optional `mail/providers/` module** so the core stays clean; declare the
  anti-feature in F-Droid metadata. Never ship a proprietary native lib (see BANNED).
- **DavMail (GPLv2)** is an **external companion**, documented for on-prem Exchange and for
  surfacing Exchange calendar/contacts as CalDAV/CardDAV. **Never bundled.**

## NOTICE & attribution
- `LICENSE` = Apache-2.0 text.
- `NOTICE` = Apache notice **+ a Third-Party Licenses section** listing every shipped dep,
  its license, and source URL, with explicit MPL-2.0 entry for `enough_mail` and entries for
  the OAuth libs. Apache §4(d) requires NOTICE be propagated.
- **In-app:** wire Flutter `showLicensePage()` into Settings → About to aggregate package
  licenses for end-user notice on store builds.

## Why this matters for distribution (App Store)
- Apache-2.0 + MPL-2.0 are App-Store-distributable. **GPL is not** (Apple's terms conflict
  with GPL's no-further-restrictions clause) — which is why Etar/Tasks/Fossify/DavMail ship
  outside the App Store. Keeping RED licenses and proprietary native libs out is what makes
  the App Store target legal **and** keeps F-Droid inclusion possible.

## Inbound contributions = outbound license
- `CONTRIBUTING.md` states **inbound = outbound (Apache-2.0)**.
- Require a **DCO** (`Signed-off-by`) so contributors assert they have the rights and aren't
  pasting copyleft code. Lightweight; no CLA.

## Standing checklist (the audit's license dimension verifies these)
1. CI license gate present and green; **no banned package** in the tree.
2. `NOTICE` lists every shipped dep incl. MPL `enough_mail` + OAuth deps.
3. No RED license anywhere in the resolved dependency tree.
4. `THIRD_PARTY_REFERENCES.md` provenance intact; no copied code.
5. `showLicensePage()` reachable from About.
6. CONTRIBUTING has inbound=outbound + DCO.
7. M365/OAuth code isolated in the optional module; F-Droid NonFreeNet declared.
