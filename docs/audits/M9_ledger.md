# Audit Ledger — Milestone M9 — 2026-06-28

(Previous ledgers archived to `docs/audits/M0_ledger.md`..`M8_ledger.md`.)

## Round 1

| id   | dimension                | sev     | status   | location                                                                  | evidence/note                                                            |
|------|--------------------------|---------|----------|---------------------------------------------------------------------------|--------------------------------------------------------------------------|
| F-01 | build & static analysis  | MINOR   | Closed   | lib/modules/notes/sync/nextcloud_notes_client.dart                         | `use_null_aware_elements` × 3 — switched from `if (x != null) 'k': x` to the new `'k': ?x` map-entry form.                                                          |
| F-02 | build & static analysis  | BLOCKER | Closed   | lib/modules/notes/ui/note_editor.dart + undo_history.dart                  | `UndoHistory` name collided with Flutter's `package:flutter/src/widgets/undo_history.dart`. Renamed to `NoteEditorHistory` (more specific anyway). |
| F-03 | build & static analysis  | MINOR   | Closed   | lib/modules/notes/ui/note_list_view.dart                                   | `prefer_const_constructors` on a Padding whose child was already const.   |
| F-04 | build & static analysis  | BLOCKER | Closed   | test/modules/notes/data/checklist_serializer_test.dart                    | `ChecklistItem` lives in `note_draft.dart`; tests imported only the serializer. Added the missing import. |
| F-05 | build & static analysis  | BLOCKER | Closed   | test/modules/notes/data/note_repository_test.dart                         | `Value` + `OrderingTerm` reachable only through drift; added `import 'package:drift/drift.dart' hide isNotNull, isNull;` per the M5-established idiom. |
| F-06 | build & static analysis  | MINOR   | Closed   | 10 files                                                                  | `dart format` autoformat.                                                |

Round summary: opened 6, closed 6, reopened 0, regressions 0.

## Confirmation pass (dims 1, 2, 3, 4, 5, 6, 7, 8)

| dim | dimension              | result                                                                                                                                          |
|-----|------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| 1   | build & static         | analyze 0 issues · `dart format --set-exit-if-changed` clean                                                                                    |
| 2   | tests                  | 175 passing · 0 unintended skips · 1 opt-in live integration skipped (M3 carryover)                                                            |
| 3   | runtime health         | undo/redo flow exercised through `undo_history_test.dart`; repo + sync tests assert no exceptions; M3 list/editor remain interactive            |
| 4   | security & privacy     | locked notes obscure the body in the list preview ("(locked)"); M11 wires biometric prompt before opening; no remote loads on render            |
| 5   | license/supply-chain   | no new deps (reuses http + xml + drift + meta); NOTICE unchanged; no banned pkg; secrets.json untracked; provenance intact                       |
| 6   | offline-first          | every CRUD path writes to NoteItems first; sync backend drains pending queue; UI reads through repo only                                       |
| 7   | data-model fidelity    | checklist round-trip canonical `- [ ]` / `- [x]` survives parse → encode → parse; favorite/locked round-trip through DB; 412 → SyncConflicts |
| 8   | UX / aesthetic         | hex grep outside tokens.dart → 0 hits; locked icon + favorite star use the single green accent only; preview obscures locked body content      |

### F-Droid modularity (carry-over from M8)

| check                                                            | result |
|------------------------------------------------------------------|--------|
| `msal_auth` in pubspec.lock                                       | absent |
| M365 identifier grep outside `modules/mail/providers/microsoft365` | 0 hits (advisory + `isolation_test.dart`) |

CONVERGED CLEAN.

## Notes
- **Null-aware map entries (`'k': ?value`) is the new idiom** for header maps and JSON bodies. Document so M10+ uses it directly instead of `if (x != null) 'k': x`.
- **Flutter exports an `UndoHistory` class** in `widgets/undo_history.dart` — our notes-specific name needed to be distinct. Renamed to `NoteEditorHistory`.
- **Lock surface is a stub at M9.** The column round-trips; the actual biometric/PIN prompt sits in `core/lock` and is wired by M11. Documented in the vignette.
- CocoaPods → SwiftPM advisory carries over.
