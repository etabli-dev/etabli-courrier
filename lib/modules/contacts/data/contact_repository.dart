import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../../core/ical/ical_property.dart';
import '../../../core/ical/ical_reader.dart';
import '../../../core/ical/ical_writer.dart';
import 'contact_draft.dart';
import 'contact_serializer.dart';

// Offline-first contact repository. Reads/writes hit CourrierDatabase first
// (AUDIT_LOOP dim 6). Sync happens via ContactsSyncBackend against the M2 DAV
// layer; this class is the canonical local source of truth.

class ContactRepository {
  ContactRepository({
    required this.db,
    ContactSerializer? serializer,
    String Function()? uidGenerator,
  }) : _serializer = serializer ?? const ContactSerializer(),
       _uidGenerator = uidGenerator ?? _defaultUidGenerator;

  final CourrierDatabase db;
  final ContactSerializer _serializer;
  final String Function() _uidGenerator;

  static const IcalReader _reader = IcalReader();
  static const IcalWriter _writer = IcalWriter();

  // ---- CRUD ---------------------------------------------------------------

  Future<int> createContact(ContactDraft draft) async {
    final uid = draft.uid ?? _uidGenerator();
    final vcard = _serializer.render(draft, uid: uid);
    final contactId = await db
        .into(db.contactCards)
        .insert(
          ContactCardsCompanion.insert(
            collectionId: draft.collectionId,
            uid: uid,
            formattedName: Value(draft.formattedName),
            givenName: Value(draft.givenName),
            familyName: Value(draft.familyName),
            organization: Value(draft.organization),
            primaryEmail: Value(draft.primaryEmail),
            primaryPhone: Value(draft.primaryPhone),
            rawVcard: vcard,
            photoRef: Value(draft.photoUri ?? draft.photoBase64),
          ),
        );
    await _syncGroupMemberships(contactId, draft.groupIds);
    await _enqueueChange(
      accountId: await _accountIdForCollection(draft.collectionId),
      contactId: contactId,
      operation: 'create',
      payload: vcard,
    );
    return contactId;
  }

  Future<void> updateContact(int contactId, ContactDraft draft) async {
    final existing = await (db.select(
      db.contactCards,
    )..where((t) => t.id.equals(contactId))).getSingleOrNull();
    if (existing == null) {
      throw StateError('Contact $contactId not found');
    }
    // Patch the existing tree so unknown X-* / TYPE param-laden EMAILs survive.
    final patched = _patchExistingVcard(existing.rawVcard, draft);
    await (db.update(
      db.contactCards,
    )..where((t) => t.id.equals(contactId))).write(
      ContactCardsCompanion(
        formattedName: Value(draft.formattedName),
        givenName: Value(draft.givenName),
        familyName: Value(draft.familyName),
        organization: Value(draft.organization),
        primaryEmail: Value(draft.primaryEmail),
        primaryPhone: Value(draft.primaryPhone),
        rawVcard: Value(patched),
        photoRef: Value(draft.photoUri ?? draft.photoBase64),
        lastModified: Value(DateTime.now()),
      ),
    );
    await _syncGroupMemberships(contactId, draft.groupIds);
    await _enqueueChange(
      accountId: await _accountIdForCollection(draft.collectionId),
      contactId: contactId,
      operation: 'update',
      payload: patched,
      baseEtag: existing.etag,
    );
  }

  Future<void> deleteContact(int contactId) async {
    final existing = await (db.select(
      db.contactCards,
    )..where((t) => t.id.equals(contactId))).getSingleOrNull();
    if (existing == null) {
      return;
    }
    await (db.update(db.contactCards)..where((t) => t.id.equals(contactId)))
        .write(const ContactCardsCompanion(deletedLocally: Value(true)));
    await _enqueueChange(
      accountId: await _accountIdForCollection(existing.collectionId),
      contactId: contactId,
      operation: 'delete',
      baseEtag: existing.etag,
    );
  }

  // ---- Groups -------------------------------------------------------------

  Future<int> createGroup({required int collectionId, required String name}) {
    return db
        .into(db.contactGroups)
        .insert(
          ContactGroupsCompanion.insert(collectionId: collectionId, name: name),
        );
  }

  Future<void> deleteGroup(int groupId) async {
    await (db.delete(
      db.contactGroups,
    )..where((t) => t.id.equals(groupId))).go();
  }

  Future<List<ContactGroup>> groupsIn(int collectionId) {
    return (db.select(
      db.contactGroups,
    )..where((t) => t.collectionId.equals(collectionId))).get();
  }

  Future<List<ContactGroupMember>> membershipsOf(int contactId) {
    return (db.select(
      db.contactGroupMembers,
    )..where((t) => t.contactId.equals(contactId))).get();
  }

  // ---- Queries ------------------------------------------------------------

  Future<List<ContactCard>> listContacts({int? collectionId}) {
    final q = db.select(db.contactCards)
      ..where((t) => t.deletedLocally.equals(false))
      ..orderBy([
        (t) => OrderingTerm.asc(t.familyName),
        (t) => OrderingTerm.asc(t.givenName),
        (t) => OrderingTerm.asc(t.formattedName),
      ]);
    if (collectionId != null) {
      q.where((t) => t.collectionId.equals(collectionId));
    }
    return q.get();
  }

  Stream<List<ContactCard>> watchContacts({int? collectionId}) {
    final q = db.select(db.contactCards)
      ..where((t) => t.deletedLocally.equals(false))
      ..orderBy([
        (t) => OrderingTerm.asc(t.familyName),
        (t) => OrderingTerm.asc(t.givenName),
        (t) => OrderingTerm.asc(t.formattedName),
      ]);
    if (collectionId != null) {
      q.where((t) => t.collectionId.equals(collectionId));
    }
    return q.watch();
  }

  // ---- Internals ----------------------------------------------------------

  String _patchExistingVcard(String existingVcard, ContactDraft draft) {
    final tree = _reader.parse(existingVcard);
    // Replace each typed field; the M2 setSingle preserves position and any
    // unknown X-* / vendor properties that surround it.
    tree.setSingle(IcalProperty(name: 'FN', value: draft.formattedName));
    if (draft.givenName != null || draft.familyName != null) {
      tree.setSingle(
        IcalProperty(
          name: 'N',
          value: '${draft.familyName ?? ''};${draft.givenName ?? ''};;;',
        ),
      );
    }
    if (draft.organization != null) {
      tree.setSingle(IcalProperty(name: 'ORG', value: draft.organization!));
    }

    // EMAIL / TEL / ADR are cardinality-N; clear and rebuild from the draft.
    tree.removeAll('EMAIL');
    for (final email in draft.emails) {
      tree.properties.add(
        IcalProperty(
          name: 'EMAIL',
          parameters: email.type == null
              ? const <String, List<String>>{}
              : <String, List<String>>{
                  'TYPE': [email.type!],
                },
          value: email.value,
        ),
      );
    }
    tree.removeAll('TEL');
    for (final phone in draft.phones) {
      tree.properties.add(
        IcalProperty(
          name: 'TEL',
          parameters: phone.type == null
              ? const <String, List<String>>{}
              : <String, List<String>>{
                  'TYPE': [phone.type!],
                },
          value: phone.value,
        ),
      );
    }
    tree.removeAll('ADR');
    for (final address in draft.addresses) {
      tree.properties.add(
        IcalProperty(
          name: 'ADR',
          parameters: address.type == null
              ? const <String, List<String>>{}
              : <String, List<String>>{
                  'TYPE': [address.type!],
                },
          value: address.toVcardValue(),
        ),
      );
    }

    if (draft.note != null) {
      tree.setSingle(IcalProperty(name: 'NOTE', value: draft.note!));
    }

    if (draft.photoBase64 != null) {
      tree.setSingle(
        IcalProperty(
          name: 'PHOTO',
          value:
              'data:${draft.photoMimeType ?? 'image/png'};base64,'
              '${draft.photoBase64}',
        ),
      );
    } else if (draft.photoUri != null) {
      tree.setSingle(IcalProperty(name: 'PHOTO', value: draft.photoUri!));
    }

    return _writer.render(tree);
  }

  Future<void> _syncGroupMemberships(int contactId, List<int> groupIds) async {
    await (db.delete(
      db.contactGroupMembers,
    )..where((t) => t.contactId.equals(contactId))).go();
    for (final groupId in groupIds) {
      await db
          .into(db.contactGroupMembers)
          .insert(
            ContactGroupMembersCompanion.insert(
              groupId: groupId,
              contactId: contactId,
            ),
          );
    }
  }

  Future<int> _accountIdForCollection(int collectionId) async {
    final c = await (db.select(
      db.collections,
    )..where((t) => t.id.equals(collectionId))).getSingle();
    return c.accountId;
  }

  Future<void> _enqueueChange({
    required int accountId,
    required int contactId,
    required String operation,
    String? payload,
    String? baseEtag,
  }) async {
    await db
        .into(db.pendingChanges)
        .insert(
          PendingChangesCompanion.insert(
            accountId: accountId,
            entityTable: 'contact_cards',
            entityId: contactId,
            operation: operation,
            baseEtag: Value(baseEtag),
            payload: Value(payload),
          ),
        );
  }
}

int _uidCounter = 0;
String _defaultUidGenerator() {
  final now = DateTime.now().toUtc();
  // millisecond + microsecond + process-local counter — keeps the UID unique
  // even when many creates happen inside the same millisecond.
  return '${now.millisecondsSinceEpoch}-${now.microsecond}-${++_uidCounter}'
      '@etabli.dev';
}
