# Tasks

![Tasks — three sample VTODO items with checkboxes and due dates](../_screens/0.1.0/04-tasks.png){width=320}

VTODO over the shared M2 DAV layer. Subtasks are wired via
`RELATED-TO;RELTYPE=PARENT`. Two recurrence modes ship:

- **Fixed RRULE** — the task carries a standard RRULE; the calendar UI can
  surface every occurrence by expansion. `complete()` flips the percent to 100
  and stamps `completed`.
- **Repeat after completion** — `complete()` advances `DUE` by the interval
  encoded in the RRULE (DAILY × INTERVAL, WEEKLY × INTERVAL, MONTHLY ×
  INTERVAL, YEARLY × INTERVAL), resets `percent` to 0, and writes
  `LAST-COMPLETED` to the rawIcs so the sync surface reflects the chain.

## Subtask model

Children carry the parent's UID in `RELATED-TO` (RELTYPE=PARENT is the default
per RFC 5545 §3.8.4.5, so we emit it explicitly). The repository's
`subtasksOf(parentUid: ...)` query surfaces the children; the list view does a
single in-memory flatten that nests roots → children → grandchildren in
document order.

## Data flow

```
TaskEditor → TaskDraft → TaskRepository
                          ├── inserts TodoItems row
                          ├── TaskSerializer renders VCALENDAR > VTODO via M2 IcalWriter
                          └── enqueues PendingChanges with baseEtag for If-Match
```

```
TasksSyncBackend.push → DavClient.put If-Match → 201 etag updates row,
                                           or 412 → SyncConflicts row
TasksSyncBackend.pull → sync-collection REPORT → changed hrefs + new sync-token
```

## Round-trip fidelity (audit dim 7)

The update path patches the existing rawIcs through the M2 reader/writer so
unknown vendor properties survive every edit. `X-TASKS-ORG-REPEAT-COMPLETED`
is the only courrier-emitted X-property; it flips the repeat-mode bit so
re-imports stay round-tripable.

## Open at M5

- The editor stays utility-grade. The Etar/Tasks-style date+priority chips
  land at M11 polish.
- `RELATED-TO` is cardinality-N in RFC 5545. We treat parent as exactly one
  (matches the M1 schema's `parentUid` column).
