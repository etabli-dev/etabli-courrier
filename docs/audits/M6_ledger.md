# Audit Ledger — Milestone M6 — 2026-06-28

(Previous ledgers archived to `docs/audits/M0_ledger.md`..`M5_ledger.md`.)

## Round 1

| id   | dimension                | sev     | status   | location                                                                  | evidence/note                                                            |
|------|--------------------------|---------|----------|---------------------------------------------------------------------------|--------------------------------------------------------------------------|
| F-01 | build & static analysis  | BLOCKER | Closed   | lib/modules/mail/backend/imap_mail_backend.dart                            | enough_mail 2.x ImapClient doesn't expose `selectedMailbox`; `MessageSequence.fromRange` no longer takes `isUidSequence`; `BuildPart.mediaType` is non-nullable; `ImapClient` has no `isLogEnabled` parameter. Replaced with stored `_selectedMailbox` from `selectMailboxByPath`. |
| F-02 | build & static analysis  | BLOCKER | Closed   | lib/modules/mail/backend/demo_mail_backend.dart                            | `library_private_types_in_public_api`: `_DemoFolder` exposed via public constructor. Removed the optional `folders` parameter — the backend always seeds the default canonical sample set; future custom-layout tests can use a public builder. |
| F-03 | build & static analysis  | MINOR   | Closed   | test/modules/mail/data/mail_repository_test.dart                          | unused drift import (Value comes through generated CourrierDatabase).    |
| F-04 | build & static analysis  | MINOR   | Closed   | 10 files                                                                  | `dart format` autoformat.                                                |

Round summary: opened 4, closed 4, reopened 0, regressions 0.

## Confirmation pass (dims 1, 2, 3, 4, 5, 6, 7, 8)

| dim | dimension              | result                                                                                                                                                |
|-----|------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1   | build & static         | analyze 0 issues · `dart format --set-exit-if-changed` clean                                                                                          |
| 2   | tests                  | 109 passing · 0 unintended skips · 1 opt-in live integration skipped (M3 carryover)                                                                   |
| 3   | runtime health         | render + repo tests exercise no exceptions; MIME render produces no widget tree, so no network call possible at render                                |
| 4   | security & privacy     | **mail_repository_test.dart asserts every newly-synced message has `remoteContentAllowed=false`; mime_render_plan_test.dart asserts remote `<img>` rewritten to `[image blocked]` placeholder + scripts stripped + javascript: URIs removed.** Reason: BUILD_PROMPT M6 + audit dim 4 invariant. |
| 5   | license/supply-chain   | enough_mail ^2.1.6 MPL-2.0 (already declared) + html ^0.15.4 BSD-3 added; NOTICE updated; no banned pkg; secrets.json untracked; provenance intact     |
| 6   | offline-first          | every UI surface reads through MailRepository → drift; backend writes (move/applyFlags/expunge) always update the DB. Body lazy on user open.          |
| 7   | data-model fidelity    | M1 schema honoured: UID + flags + special-use + remoteContentAllowed + bodyDownloaded + trashed/trashedAt. Restore clears the tombstone; emptyTrash deletes from DB.|
| 8   | UX / aesthetic         | hex grep outside tokens.dart → 0 hits; single green accent on the thread unread dot + permission-card; remote-content card surfaces as actionable UI (no silent fail) |

CONVERGED CLEAN.

## Notes
- **Remote content posture is enforced at three points:** (a) DB default-off (`MailMessages.remoteContentAllowed=false`), (b) renderer replaces remote `<img>` with a placeholder regardless of allowed flag (the M6 read path emits text only — no widget can fetch), (c) UI surfaces the toggle when `containedRemoteContent=true` AND `!remoteContentAllowed`. The test that asserts the DB default acts as the audit-dim-4 gate.
- The IMAP backend's connect path handles BOTH `PasswordCredentials` and `XoauthBearerCredentials`. M8 only adds the `core/auth` plumbing on top — no protocol fork.
- CocoaPods → SwiftPM advisory carries over.
