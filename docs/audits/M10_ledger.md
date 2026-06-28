# Audit Ledger — Milestone M10 — 2026-06-28

(Previous ledgers archived to `docs/audits/M0_ledger.md`..`M9_ledger.md`.)

## Round 1

| id   | dimension                | sev     | status   | location                                                                  | evidence/note                                                            |
|------|--------------------------|---------|----------|---------------------------------------------------------------------------|--------------------------------------------------------------------------|
| F-01 | build & static analysis  | MINOR   | Closed   | lib/modules/feeds/sync/feeds_sync_backend.dart                            | unused `database.dart` import + `prefer_initializing_formals` on `_parser`. Renamed to public `parser` field with the default value on the parameter. |
| F-02 | build & static analysis  | MINOR   | Closed   | 10 files                                                                  | `dart format` autoformat                                                |

Round summary: opened 2, closed 2, reopened 0, regressions 0.

## Confirmation pass (dims 1, 2, 3, 4, 5, 6, 7, 8)

| dim | dimension              | result                                                                                                                                          |
|-----|------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| 1   | build & static         | analyze 0 issues · `dart format --set-exit-if-changed` clean                                                                                    |
| 2   | tests                  | 190 passing · 0 unintended skips · 1 opt-in live integration skipped (M3 carryover)                                                            |
| 3   | runtime health         | CustomIntervalPicker widget tests render clean; parser tests assert no exceptions on malformed input (returns null / skips bad items)         |
| 4   | security & privacy     | News API uses Basic auth via M2's `DavCredentials` (M11 wires session re-auth on 401); item content stored locally as raw HTML — the M6 remote-content-off-by-default posture from the mail module applies if/when feeds adopt a HTML viewer; M10 emits plain text snippets in the list  |
| 5   | license/supply-chain   | no new deps (reuses xml + http + drift + meta); NOTICE unchanged; no banned pkg; secrets.json untracked; provenance intact                       |
| 6   | offline-first          | every read path goes through FeedRepository → DB; pull writes through repo upsert; refresh-interval persists in the subscription row             |
| 7   | data-model fidelity    | upsertItem idempotent on (feedId, guid) — proven by `feed_repository_test.dart::upsertItem is idempotent`; RSS pubDate normalises to UTC; Atom prefers rel=alternate link |
| 8   | UX / aesthetic         | hex grep outside tokens.dart → 0 hits; single green accent on unread dot + unread-count chip + picker segmented selection                       |

### F-Droid modularity (carry-over from M8)

| check                                                            | result |
|------------------------------------------------------------------|--------|
| `msal_auth` in pubspec.lock                                       | absent |
| M365 identifier grep outside `modules/mail/providers/microsoft365` | 0 hits |

CONVERGED CLEAN.

## Notes
- **The bundled FeedParser is the F-Droid safety net** — every feed the user subscribes to outside their Nextcloud News install reads through it, no third-party HTTP API in the loop. The parser is 240 lines covering RSS 2.0 + Atom 1.0 + the common date suffix idioms.
- **CustomIntervalPicker is shared.** M11 reminder editor + Feeds settings + any future module that needs minute/hour/day intervals use the same widget.
- **News API push is a no-op at M10.** M11 wires a pending-changes queue for read-state mirrors so a read on one device propagates to the others.
- CocoaPods → SwiftPM advisory carries over.
