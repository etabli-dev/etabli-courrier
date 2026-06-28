# AUDIT_LOOP.md — multi-round iterative audit → refine engine

> Run this at **every milestone gate** (scoped to the milestone) and as a **global
> pre-release pass** (M12 and M15, full app). It is the mechanism behind every STOP and
> encodes the zero-warning, reason-first principles from CLAUDE.md as a repeatable loop.

---

## 0. Vocabulary
- **Audit dimension** — one category of checks (§1). A round runs all *applicable* ones.
- **Finding** — a single defect: `{id, dimension, severity, evidence, location}`.
- **Findings Ledger** — open findings for the current run → `AUDIT_LEDGER.md`.
- **Round** — one full audit pass + the refinement of every finding it produced.
- **Convergence** — a round that produces an **empty** ledger across all dimensions.

---

## 1. Audit dimensions (a round checks every applicable one)

1. **Build & static analysis** — compiles; `flutter analyze` = 0 issues (errors, warnings,
   **and infos**); `dart format --set-exit-if-changed .` clean.
2. **Tests** — unit/widget/integration all green, **none skipped**; critical paths covered
   (sync reconciliation, recurrence/EXDATE, iCal/vCard round-trip, MIME parse, reminder
   re-arm, **OAuth token refresh**).
3. **Runtime health** — launches on emulator; each in-scope flow exercised; **no** exception,
   yellowbox, framework assertion, or `debugPrint` warning; **no dropped frames** (profile
   mode) on exercised flows.
4. **Security & privacy** — no secret/**OAuth token** in plaintext, logs, or shared prefs;
   secrets/tokens via `flutter_secure_storage` only; **no test-credentials file committed**
   (`secrets.json` gitignored; only public config such as the M365 client ID may live
   in-repo); no telemetry/trackers; `PrivacyInfo.xcprivacy` present and accurate.
5. **License & supply-chain compliance** — dependency allow-list gate passes (LICENSING.md);
   **no banned package** (`msal_auth` / proprietary native MSAL); `NOTICE` current incl.
   every shipped dep + MPL `enough_mail` + OAuth deps; **no GPL/AGPL/LGPL** in the tree;
   the **M365/OAuth code is contained in the optional module** (F-Droid core stays clean,
   NonFreeNet declared); clean-room provenance intact (THIRD_PARTY_REFERENCES.md).
6. **Offline-first correctness** — every module reads/writes local DB first; sync idempotent
   (run twice → no dupes/divergence); conflicts surface in **UI**.
7. **Data-model fidelity** — iCal/vCard round-trips **preserve unknown properties**; stable
   UID vs etag; recurrence exceptions (EXDATE/RECURRENCE-ID) preserved; subtasks
   (`RELATED-TO`) preserved.
8. **UX / aesthetic conformance** — `grep` for hex colors outside the theme token file
   returns **nothing**; Auto/Light/Dark correct; borders-over-shadows; single green accent;
   **no** arbitrary color customization or freemium UI; **tenant/OAuth error states render
   (no silent fail/crash)**.
9. **Accessibility** — semantics labels on interactive elements; contrast adequate; tap
   targets ≥ 48dp.
10. **Documentation** — a vignette section exists for every shipped feature (incl. M365 +
    DavMail how-tos); screenshots current (M13 harness); What's-New updated.

> Scope per milestone: run the dimensions it touches. A milestone adding no UI still runs
> 1, 2, 5; one adding a synced module runs 1–8 minimum; M8 additionally stresses 4, 5, 8.

---

## 2. Severity
- **BLOCKER** — violates the zero-warning policy or any dimension's hard requirement.
- **MAJOR** — correctness/security/license risk not yet user-visible.
- **MINOR** — polish, doc gap, weak test.

**Gate rule:** because warnings are treated as failures, a round **passes only when the
ledger is empty of findings of ANY severity** and a fresh full pass reproduces zero
findings. There is no "accept MINOR and ship."

---

## 3. Round mechanics (the loop)

```
ROUND n:
  1. AUDIT  — run all applicable dimensions (§1). Record every finding in AUDIT_LEDGER.md.
  2. If ledger is EMPTY:
        run one CONFIRMATION audit (full re-run of applicable dimensions).
        If still empty  -> CONVERGED. Exit loop, proceed to the milestone STOP.
        If not          -> the new findings are this round's; continue to step 3.
  3. REFINE — for EACH finding, before touching code, write to BUILD_LOG.md:
        Hypothesis -> Strategy -> Verification plan -> Fallback   (reason-first)
        Then apply the fix. Then RE-RUN that finding's dimension to verify it closed.
        Mark Closed (with evidence) or Reopened (with the failed verification).
  4. When all findings are Closed -> start ROUND n+1 (re-audit from clean).
```
A finding is never closed by suppression, lint-ignore, skipped test, or a `// TODO`.

---

## 4. Caps & guards (STOP conditions — escalate, never silence)
- **Round cap: 10.** If round 10 does not converge → **STOP**. Emit the full ledger + all
  reason-first logs + a blunt assessment of why. Do not ship.
- **Oscillation guard.** If the *same* finding (same dimension + location) reopens across
  **3 rounds** → **STOP**. Recurrence means the fix strategy is wrong, not mistuned.
- **Regression guard.** If a round introduces a finding in a dimension that was clean in a
  prior round, flag `REGRESSION` (treat as BLOCKER); regressions in **2** consecutive rounds
  → **STOP**.
- **Scope-creep guard.** If closing a finding needs work outside the milestone's scope →
  **STOP** and ask, rather than silently expanding scope.

---

## 5. Artifacts the loop writes

### 5.1 `AUDIT_LEDGER.md` (current run — overwrite each milestone, archive prior to `docs/audits/`)
```
# Audit Ledger — Milestone <id> — <date>
Round <n>:
| id   | dimension            | sev     | status   | location              | evidence/note          |
|------|----------------------|---------|----------|-----------------------|------------------------|
| F-01 | license/supply-chain | BLOCKER | Closed   | pubspec.yaml          | removed msal_auth      |
| F-02 | data-model fidelity  | MAJOR   | Open     | lib/.../ical.dart     | EXDATE dropped on PUT  |
Round summary: opened <x>, closed <y>, reopened <z>, regressions <r>.
```

### 5.2 Per-milestone audit report (print at the STOP, append to BUILD_LOG.md)
```
AUDIT — Milestone <id> — CONVERGED in <n> rounds (cap 10)
- Dimensions run: <list>
- Total findings: <opened> | Closed: <all> | Reopened events: <count>
- Regressions: none | Oscillation stops: none
- analyze: 0 issues | tests: <p> passing, 0 skipped | jank: none
- license gate: pass | banned pkg: none | NOTICE: current | provenance: intact
- Open questions for human: <list or none>
CONVERGED CLEAN. AWAITING APPROVAL FOR MILESTONE <id+1>.
```
Escalation variant:
```
AUDIT — Milestone <id> — NOT CONVERGED — ESCALATION
- Reason: <round cap | oscillation | regression | scope-creep>
- Outstanding findings: <ledger excerpt>
- Reason-first logs: <pointer to BUILD_LOG entries>
HALTED. HUMAN DECISION REQUIRED.
```

---

## 6. Global pre-release pass (M12 and M15)
Same engine, **all 10 dimensions, whole app**, cap 10. M15 additionally requires: license
gate green, no banned package, **M365 module modular with NonFreeNet declared**, `NOTICE`
final, privacy manifest present, funding surfaces correct per flavor, Maestro gallery
complete, every shipped feature documented (incl. M365 + DavMail how-tos). Only a converged
M15 may cut **GitHub Release v0.1.0**.
