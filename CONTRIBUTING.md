# Contributing to `courrier`

Thanks for helping build `courrier`, a member of the Établi Suite.

## Licensing of contributions (please read)
- **Dual-licensed project.** `courrier` is licensed AGPL-3.0-only, or commercially by the
  copyright holder (etabli.dev@outlook.com). Please open an issue before proposing changes; contributions can only
  be accepted under a written contributor agreement that allows both licences.
- **Developer Certificate of Origin (DCO).** Every commit must also be signed off:
  ```
  git commit -s -m "Your message"
  ```
  The `Signed-off-by:` line certifies you wrote the change or otherwise have the right to
  submit it under that agreement (https://developercertificate.org).
- **No copyleft code.** Do not paste or adapt code from GPL/AGPL/LGPL projects (e.g. Fossify,
  Etar, Tasks.org, DavMail). You may reimplement *behavior* independently, but never copy
  source. Code from MPL-2.0 or Apache-2.0 projects requires prior discussion and proper
  attribution — open an issue before submitting such a PR.
- **New dependencies** must carry an allow-listed license (see `LICENSING.md`) and be added
  to `NOTICE`. The CI license gate will fail otherwise.
- **Banned dependencies.** Do **not** add `msal_auth` or any wrapper of Microsoft's
  proprietary native MSAL binaries — it breaks F-Droid. Use `flutter_appauth` (PKCE) for
  OAuth.

## Microsoft 365 / OAuth contributions
- The M365/Gmail OAuth code lives in the **optional `mail/providers/` module** so the
  F-Droid core stays clean. Keep it there; do not wire proprietary-service code into core.
- Do **not** reuse another project's OAuth client ID (e.g. Thunderbird's). `courrier` uses
  its **own** project-owned Entra **public-client** registration (no secret, PKCE).
- Tenant/OAuth error paths (admin-consent-required, app blocked, IMAP/SMTP disabled) must be
  handled as visible, actionable UI states — never a silent failure or crash.

## Quality bar (enforced)
PRs must meet this quality bar:
- `flutter analyze` — **zero** issues (errors, warnings, and infos).
- `dart format` — clean.
- `flutter test` — all green, none skipped.
- No new runtime warnings, framework assertions, overflow/key warnings, or dropped frames.
- New user-facing features include their vignette/doc section.
- No hardcoded colors (use `core/theme` tokens and `Theme.of(context).colorScheme.primary` for the accent);
  respect System/Light/Dark and the user's accent.
- Every user-facing string in English and German (`lib/l10n/app_en.arb`, `app_de.arb`, then
  `flutter gen-l10n`); no button, tab, chip or menu label may wrap on a 375-pt phone in either language.

## Workflow
1. Open an issue to discuss non-trivial changes first.
2. Branch and keep the change to the scope agreed in the issue.
3. Run the quality-bar checks above locally until they are clean.
4. Submit a signed-off PR describing what changed and how you verified it.

**Running locally:** copy `secrets.example.json` → `secrets.json` (gitignored), fill in your
own test Nextcloud / IMAP / M365 values, then run
`flutter run --dart-define-from-file=secrets.json`. See **PREFLIGHT.md**. Never commit
`secrets.json`.

## Scope reminders (deliberate non-goals)
`courrier` is **paid-upfront, no IAP** (no freemium/feature-locking), uses the **suite's accent
set** (Coder blue by default; the owner's seven colours of 2026-11-24, no free colour picker), and owns
its **own DAV/offline layer** (no
dependency on a system PIM provider). Microsoft **Graph** and **DavMail** integration are
**post-v0.1.0**; DavMail is documented, never bundled. PRs contradicting these are out of
scope by design.
