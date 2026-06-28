# Audit Ledger — Milestone M7 — 2026-06-28

(Previous ledgers archived to `docs/audits/M0_ledger.md`..`M6_ledger.md`.)

## Round 1

| id   | dimension                | sev     | status   | location                                                                  | evidence/note                                                            |
|------|--------------------------|---------|----------|---------------------------------------------------------------------------|--------------------------------------------------------------------------|
| F-01 | build & static analysis  | BLOCKER | Closed   | lib/modules/mail/backend/demo_mail_backend.dart                            | `library_private_types_in_public_api` on `DemoSentRecord`'s precursor `_SentRecord` exposed via the public `sentLog` getter. Promoted to `DemoSentRecord` class. |
| F-02 | build & static analysis  | BLOCKER | Closed   | lib/modules/mail/backend/demo_mail_backend.dart                            | DemoMailBackend implements MailBackend (no extends), so the new `startIdle`/`stopIdle` defaults in the abstract didn't transfer — added explicit no-op overrides. |
| F-03 | build & static analysis  | MINOR   | Closed   | lib/modules/mail/backend/imap_mail_backend.dart                            | `SmtpClient` constructor doesn't take `isLogEnabled` in enough_mail v2.                                                                                            |
| F-04 | build & static analysis  | MINOR   | Closed   | lib/modules/mail/compose/compose_repository.dart                            | unused `mail_backend.dart` import; redundant `Value.absent()` argument.                                                                                            |
| F-05 | tests                    | BLOCKER | Closed   | test/modules/mail/compose/compose_repository_test.dart (2 tests)            | DemoMailBackend's `_extractHeader` regex over-escaped `$` (Dart string `"\\\$"` produces literal `\$` in regex, not end-of-line anchor). Replaced with `r'^…:\s*(.+)$'` using a raw string. |
| F-06 | tests                    | BLOCKER | Closed   | test/modules/mail/autoconfig/autoconfig_resolver_test.dart::SRV fallback   | Test passed `const` SRV records (unmodifiable list); resolver tried to sort the input list in-place. Switched to defensive copy: `List<SrvLookupResult>.of(...)..sort(...)`. |
| F-07 | build & static analysis  | MINOR   | Closed   | test files                                                                | redundant `prefer_final_locals` + missing return-type on noSuchMethod + missing MailBackend import. Multiple closures.                                              |
| F-08 | build & static analysis  | MINOR   | Closed   | 14 files                                                                  | `dart format` autoformat.                                                                                                                                          |

Round summary: opened 8, closed 8, reopened 0, regressions 0.

## Confirmation pass (dims 1, 2, 3, 4, 5, 6, 7, 8)

| dim | dimension              | result                                                                                                                                                                                |
|-----|------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1   | build & static         | analyze 0 issues · `dart format --set-exit-if-changed` clean                                                                                                                          |
| 2   | tests                  | 129 passing · 0 unintended skips · 1 opt-in live integration skipped (M3 carryover)                                                                                                   |
| 3   | runtime health         | no exceptions / overflows / dropped frames in widget-test scope; IdleListener stop is idempotent                                                                                       |
| 4   | security & privacy     | sendMessage uses STARTTLS by default; XoauthBearerCredentials path keeps the access token out of the SMTP AUTH plain-text path; remote-content posture from M6 unchanged              |
| 5   | license/supply-chain   | no new deps in M7 (uses M6's `enough_mail` + the always-present `http` + `xml`); NOTICE unchanged; no banned pkg; secrets.json untracked                                              |
| 6   | offline-first          | sendNow appends the Sent copy locally as well as on the wire; saveDraft mirrors the Drafts append; IncrementalSyncer runs inside a single drift transaction                          |
| 7   | data-model fidelity    | drafts insert with `bodyDownloaded=true` + `remoteContentAllowed=false` + sentAt unset (Drafts), Sent inserts with sentAt=now + receivedAt=now; flag deltas preserved by IncrementalSyncer |
| 8   | UX / aesthetic         | hex grep outside tokens.dart → 0 hits; ComposeView uses theme tokens only; Send/Save buttons disable + label as "Sending…" so failures aren't silent                                  |

CONVERGED CLEAN.

## Notes
- **Autoconfig waterfall design.** AutoconfigResolver is a pure data layer.
  The test surface uses MockClient + a fake SrvResolver and a Mozilla-shaped
  `clientConfig` XML fixture (`test/fixtures/autoconfig/example_org_clientconfig.xml`).
  Hardening: ISPDB hit short-circuits the subsequent steps — proven by counting
  the request hits.
- **IDLE design contract.** `IdleListener` is the foreground engine; iOS
  background-fetch is documented as M11 polish (lifecycle observers + a
  polling timer wrapped around `IncrementalSyncer.sync`).
- **CONDSTORE / QRESYNC.** The UID-diff fallback ships M7 and is test-covered.
  Server-advertised CONDSTORE will be wired in M11 once the IMAP backend
  surfaces capability detection on connect; until then, the UID-diff fallback
  is correct (just less efficient).
- **Live gate** ready to run with secrets.json populated for `IMAP_*` + `SMTP_*`.
- CocoaPods → SwiftPM advisory carries over.
