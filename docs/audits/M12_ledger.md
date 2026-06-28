# Audit Ledger — Milestone M12 — 2026-06-28

(Previous ledgers archived to `docs/audits/M0_ledger.md`..`M11_ledger.md`.)

## Round 1 — Global pre-release audit (AUDIT_LOOP.md §6)

| id   | dimension                | sev     | status   | location                                                                  | evidence/note                                                            |
|------|--------------------------|---------|----------|---------------------------------------------------------------------------|--------------------------------------------------------------------------|
| F-01 | accessibility            | MINOR   | Closed   | lib/modules/calendar/ui/event_editor.dart                                 | "Remove reminder" IconButton had no tooltip — added.                       |
| F-02 | accessibility            | MINOR   | Closed   | lib/modules/contacts/contacts_screen.dart                                 | "Back to contacts list" IconButton had no tooltip — added.                |

Round summary: opened 2, closed 2, reopened 0, regressions 0.

## Confirmation pass (all 10 dimensions, whole app)

| dim | dimension              | result                                                                                                                                          |
|-----|------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| 1   | build & static         | `flutter analyze` → 0 issues · `dart format --set-exit-if-changed` → clean (171 files, 0 changed)                                                |
| 2   | tests                  | 205 passing · 0 unintended skips · 1 opt-in live integration skipped (M3 carryover)                                                            |
| 3   | runtime health         | profile-mode jank check is device-only — checklist landed at `docs/audits/M15_jank_checklist.md` for the M15 release-gate to drive               |
| 4   | security & privacy     | no `print` / `debugPrint` / `log` calls anywhere in `lib/`; every password/token reference is in the legitimate credentials/auth/secrets path    |
| 5   | license/supply-chain   | NOTICE current with every shipped dep + MPL `enough_mail` entry; no banned pkg (`msal_auth` absent); secrets.json untracked; provenance file present |
| 6   | offline-first          | every module that mutates persistent state has a `*_repository.dart` that writes DB-first; sync backends drain `PendingChanges`; UI reads through repos |
| 7   | data-model fidelity    | `rawIcs` (calendar + tasks) and `rawVcard` (contacts) columns intact in the schema; M2 reader/writer preserves unknown properties (covered by M2 + M3 + M4 + M5 test suites); UID + etag distinct |
| 8   | UX / aesthetic         | hex grep outside `lib/core/theme/tokens.dart` → 0 hits; single green accent only; borders-over-shadows on every card/list                       |
| 9   | accessibility          | every IconButton carries a `tooltip` (verified manually + checked at: event_editor, contacts_screen, note_editor, conflict_resolution_dialog); SettingsScreen wraps controls with `Semantics` labels; Material defaults handle tap targets ≥48dp + WCAG AA contrast for the M0 token palette |
| 10  | documentation          | every module has a vignette: `calendar.md`, `contacts.md`, `feeds.md`, `mail.md` (M6+M7), `m365.md` (M8 provider), `notes.md`, `onboarding.md` (M11 shell+onboarding), `reminders.md`, `tasks.md` |

### F-Droid modularity

| check                                                            | result |
|------------------------------------------------------------------|--------|
| `msal_auth` in pubspec.lock                                       | absent |
| M365 identifier grep outside `modules/mail/providers/microsoft365` | 0 hits (advisory grep + `isolation_test.dart` hard gate) |

CONVERGED CLEAN (round 1).

## Notes — what M12 confirmed across the whole tree

- **Zero analyzer findings, 205/205 tests, format clean** after 11 milestones of accumulation.
- **a11y dim 9 promoted from "started" to "complete on widget code".** Cross-tree IconButton sweep + Semantics-on-Settings wrap. M15 device pass adds VoiceOver / TalkBack rotor verification.
- **Profile-mode jank check is device-only.** The M15 release-gate carries a 14-row jank checklist (`docs/audits/M15_jank_checklist.md`) covering mail thread scroll, calendar swipe, contacts scroll, search fan-out, onboarding, lock, reminder fire + reboot re-arm.
- **No production bug surfaced this sweep.** Two missing tooltips were the entire round-1 ledger; no regression in any prior milestone's invariants.
- **CocoaPods → SwiftPM advisory** has carried since M2. It's a `flutter pub get` informational, not a deprecation; defer until M15 if we want to enable SwiftPM-only mode (delete Podfile + xcconfig includes).

## Standing invariants verified at M12

- Hex literals only in `lib/core/theme/tokens.dart` (audit dim 8 hex grep).
- M365 identifiers only in `lib/modules/mail/providers/microsoft365/` (F-Droid grep + build-time isolation test).
- `msal_auth` banned (`pubspec.lock` scan).
- `secrets.json` gitignored + untracked.
- NOTICE current, every shipped dep enumerated, MPL `enough_mail` entry present.
- THIRD_PARTY_REFERENCES.md clean-room provenance intact.
- No GPL/AGPL/LGPL in the resolved dep tree.
