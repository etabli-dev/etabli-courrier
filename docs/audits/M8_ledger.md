# Audit Ledger — Milestone M8 — 2026-06-28

(Previous ledgers archived to `docs/audits/M0_ledger.md`..`M7_ledger.md`.)

## Round 1

| id   | dimension                | sev     | status   | location                                                                  | evidence/note                                                            |
|------|--------------------------|---------|----------|---------------------------------------------------------------------------|--------------------------------------------------------------------------|
| F-01 | build & static analysis  | BLOCKER | Closed   | lib/core/auth/app_auth_oauth_provider.dart                                | flutter_appauth v9 surface differences: exception class is `FlutterAppAuthPlatformException` not `FlutterAppAuthException`; `message` is nullable. Updated catch clauses + null-safe accesses. |
| F-02 | build & static analysis  | BLOCKER | Closed   | lib/core/auth/app_auth_oauth_provider.dart                                | `implements OAuthProvider` without `extends` doesn't inherit default `signOut` body. Added explicit no-op override that documents the contract (token wipe handled at the call site). |
| F-03 | build & static analysis  | MINOR   | Closed   | lib/core/auth/oauth_provider.dart                                         | `AuthBundle` ctor not const despite being `@immutable`.                  |
| F-04 | build & static analysis  | MINOR   | Closed   | lib/modules/mail/providers/microsoft365/m365_backend.dart                 | `prefer_initializing_formals` on a defaulted `_classifier` field. Renamed to public `classifier` so the initializer + default value live on the same parameter. |
| F-05 | build & static analysis  | MINOR   | Closed   | lib/modules/mail/providers/microsoft365/ui/tenant_error_card.dart         | `avoid_redundant_argument_values` (`adminDocsCta: null` matches the default).|
| F-06 | build & static analysis  | BLOCKER | Closed   | test/modules/mail/providers/microsoft365/m365_backend_test.dart            | FSS v10 renamed `IOSOptions`/`MacOsOptions` → `AppleOptions`. In-memory backend signatures updated to match.                                                          |
| F-07 | tests / F-Droid          | BLOCKER | Closed   | lib/core/auth/oauth_provider.dart                                          | The new isolation test caught `login.microsoftonline.com` in a docstring on `OAuthClientConfig.issuer`. Rewrote the comment to be vendor-agnostic. **Working as intended — this is exactly the leak the test exists to catch.** |
| F-08 | build & static analysis  | MINOR   | Closed   | 10 files                                                                  | `dart format` autoformat.                                                |

Round summary: opened 8, closed 8, reopened 0, regressions 0.

## Confirmation pass (dims 1, 2, 3, 4, 5, 6, 7, 8)

| dim | dimension              | result                                                                                                                                                                                |
|-----|------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1   | build & static         | analyze 0 issues · `dart format --set-exit-if-changed` clean                                                                                                                          |
| 2   | tests                  | 153 passing · 0 unintended skips · 1 opt-in live integration skipped (M3 carryover)                                                                                                  |
| 3   | runtime health         | M365Backend tests assert no exceptions surface from sign-in/refresh/connect paths; ConnectMicrosoftScreen render path proves admin-consent + generic-failure both render an actionable card |
| 4   | security & privacy     | access tokens kept in memory only (M365Backend); refresh tokens persisted only via SecretsStore (flutter_secure_storage); no client secret; PKCE; AppAuth's system-browser handoff means courrier never sees the user's tenant password |
| 5   | license/supply-chain   | flutter_appauth ^9.0.0 added — MIT (package) + Apache-2.0 (AppAuth upstream) — both GREEN; NOTICE updated; no banned pkg (`msal_auth` absent); secrets.json untracked; provenance intact |
| 6   | offline-first          | no offline-first change in M8; M6/M7 invariants untouched                                                                                                                            |
| 7   | data-model fidelity    | bearer credentials carry expiry; AuthBundle.willExpireSoon drives the silent-refresh path; refresh-rotated refresh tokens persisted in place                                          |
| 8   | UX / aesthetic         | hex grep outside tokens.dart → 0 hits; TenantErrorCard surfaces every PREFLIGHT-listed friction case with title + body + optional admin-docs CTA + Try-again — **no silent fail** |

### Audit dim 5 + F-Droid modularity addendum

| check                                                                          | result |
|--------------------------------------------------------------------------------|--------|
| `msal_auth` in pubspec.lock                                                    | absent (banned) |
| M365 identifier grep (`login.microsoftonline.com` / `outlook.office365.com` / `outlook.office.com` / `smtp.office365.com`) outside `lib/modules/mail/providers/microsoft365/` | 0 hits (advisory grep + `isolation_test.dart` hard gate)|
| NonFreeNet anti-feature declared                                                | deferred to F-Droid metadata at M15; flagged here so the M15 release-gate doesn't drop it |

CONVERGED CLEAN.

## Notes
- **F-Droid isolation is now enforced at the test layer.** `isolation_test.dart` reads every `.dart` file under `lib/` and fails the build when an M365 identifier appears outside the provider module. The license-gate.yml advisory grep remains; M11 polish promotes it into a hard CI gate.
- **flutter_appauth v9 API drift was a real cost.** Worth flagging in the BUILD_LOG so the M9+ pattern (add a dep → check its public-surface delta against the version we drafted against) is automatic.
- **No protocol fork.** M365Backend wraps the M6 ImapMailBackend — the OAuth flow lives entirely outside the IMAP/SMTP stack. Gmail v2 will reuse `core/auth` + `OAuthProvider` unchanged and plug in a `GmailConfig` + `GmailBackend`.
- CocoaPods → SwiftPM advisory carries over.
