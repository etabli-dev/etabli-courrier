# Contacts

The Contacts module turns the M1 schema and the M2 CardDAV/iCal layer into a
working VCARD-4.0 vertical: list, detail, editor, repository, and a sync
backend that mirrors the calendar one shape-for-shape.

## Surface

- **List view** — alphabetical (family → given → formatted name), a 36×36
  bordered initial chip on the left of each row, organization and primary
  email as subtitles. Renders a clean empty state when the address book is
  fresh.
- **Detail view** — display name + organization at the top, then sections for
  Email / Phone / Address surfaced directly from the stored raw vCard via the
  M2 VCard lens. Sections that are empty are silently hidden.
- **Editor** — display name, given/family split, organization, multi-line
  emails / phones / note, group memberships via checkboxes pulled from a
  supplied list.

## Data flow

```
ContactEditor → ContactDraft → ContactRepository
                                ├── inserts ContactCards row
                                ├── ContactSerializer renders VCARD 4.0 via M2 IcalWriter
                                ├── group memberships replaced atomically
                                └── enqueues PendingChanges with baseEtag for If-Match
```

```
ContactsSyncBackend.push → DavClient.put If-Match → 201 etag updates row,
                                          or 412 PreconditionFailedError → SyncConflicts row
ContactsSyncBackend.pull → SyncCollectionClient.run → changed/deleted hrefs + new sync-token
```

## Round-trip fidelity (audit dim 7)

When the user edits an existing contact whose `rawVcard` already carries
vendor X-* properties (`X-IM-SLACK`, `X-CUSTOM-VENDOR-NOTE`, …), the editor
does **not** re-render from scratch. Instead `ContactRepository.updateContact`
parses the stored vCard through the M2 reader, surgically swaps the typed
properties (FN, N, ORG, multi-value EMAIL/TEL/ADR, NOTE, PHOTO), and re-renders
through the M2 writer. The test
`contact_repository_test.dart::updateContact preserves unknown X-* properties
across an edit` asserts this on the `vcard_full.vcf` fixture.

## Photo handling

Two paths:

- `photoBase64` + `photoMimeType` → renders `PHOTO:data:<mime>;base64,<…>`.
  Small avatars or anything coming from the system image picker land here.
- `photoUri` → renders `PHOTO:<uri>` verbatim. Hosted images or local files.

The repository persists whichever is set to `ContactCards.photoRef` so the
editor can surface the same source on a subsequent edit. Cropping and scaling
are M11 polish.

## Groups

`ContactGroups` rows live per collection; `ContactGroupMembers` is the
many-to-many join. `ContactRepository.createGroup` / `deleteGroup` /
`groupsIn` / `membershipsOf` are the only API surface — the editor checks
the boxes, the repository persists.

## Sync backend

`ContactsSyncBackend` matches the calendar backend's shape:

- `pull(accountId)` walks every enabled `kind='contacts'` collection,
  runs `sync-collection` REPORT, drops `etag` rows on token reset, bumps
  `lastSyncedAt`.
- `push(accountId)` drains the pending queue for `entityTable='contact_cards'`,
  PUTs with `If-Match` (or `If-None-Match: *` on create), reads the response
  etag back into the row, and surfaces 412 as `SyncConflicts`.

## Open at M4

- The live Nextcloud round-trip test for **contacts** isn't wired (the calendar
  one is and exercises the same DAV stack). When the user provides credentials
  the calendar gate validates the DAV layer end-to-end; a parallel contacts
  integration test is straightforward to add at M11 polish.
- Group representation as VCARD `KIND:group` + `MEMBER:` is not yet emitted on
  the wire; M4 groups are local-only. The schema already carries them; sync
  parity is M11 polish.
