import 'dart:io';

import 'package:courrier/core/db/database.dart';
import 'package:courrier/modules/contacts/data/contact_draft.dart';
import 'package:courrier/modules/contacts/data/contact_repository.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

CourrierDatabase _db() => CourrierDatabase.forTesting(NativeDatabase.memory());

Future<int> _seedAccountWithCollection(CourrierDatabase db) async {
  final accountId = await db
      .into(db.accounts)
      .insert(AccountsCompanion.insert(kind: 'local', displayName: 'demo'));
  return db
      .into(db.collections)
      .insert(
        CollectionsCompanion.insert(
          accountId: accountId,
          kind: 'contacts',
          displayName: 'Address book',
        ),
      );
}

void main() {
  group('ContactRepository CRUD', () {
    test('createContact stores vCard + enqueues pending change', () async {
      final db = _db();
      addTearDown(db.close);
      final collectionId = await _seedAccountWithCollection(db);
      final repo = ContactRepository(
        db: db,
        uidGenerator: () => 'contact-uid-1',
      );

      final id = await repo.createContact(
        ContactDraft(
          collectionId: collectionId,
          formattedName: 'Ada Lovelace',
          givenName: 'Ada',
          familyName: 'Lovelace',
          organization: 'Analytical Engines',
          emails: const [
            ContactEmail(value: 'ada@example.org', type: 'work'),
            ContactEmail(value: 'lovelace@example.net', type: 'home'),
          ],
          phones: const [ContactPhone(value: '+44-20-7000-1815', type: 'cell')],
        ),
      );

      final card = await (db.select(
        db.contactCards,
      )..where((t) => t.id.equals(id))).getSingle();
      expect(card.uid, 'contact-uid-1');
      expect(card.formattedName, 'Ada Lovelace');
      expect(card.primaryEmail, 'ada@example.org');
      expect(card.rawVcard.contains('UID:contact-uid-1'), isTrue);
      expect(card.rawVcard.contains('FN:Ada Lovelace'), isTrue);
      // M2 IcalProperty.renderUnfolded quotes param values that contain
      // anything other than "alphanumeric + dash". For our simple TYPE=work
      // case (no special chars) it stays unquoted.
      expect(card.rawVcard.contains('EMAIL;TYPE=work:ada@example.org'), isTrue);

      final pending = await db.select(db.pendingChanges).get();
      expect(pending, hasLength(1));
      expect(pending.first.operation, 'create');
    });

    test(
      'updateContact preserves unknown X-* properties across an edit',
      () async {
        final db = _db();
        addTearDown(db.close);
        final collectionId = await _seedAccountWithCollection(db);

        // Seed a row whose rawVcard already carries vendor X-* + a non-standard
        // PHOTO URI — exactly the shape that comes back from a CardDAV PROPFIND.
        final source = File(
          'test/fixtures/ical/vcard_full.vcf',
        ).readAsStringSync();
        final id = await db
            .into(db.contactCards)
            .insert(
              ContactCardsCompanion.insert(
                collectionId: collectionId,
                uid: 'vcard-uid-001',
                formattedName: const Value('Ada Lovelace'),
                rawVcard: source,
              ),
            );

        final repo = ContactRepository(db: db);
        await repo.updateContact(
          id,
          ContactDraft(
            collectionId: collectionId,
            uid: 'vcard-uid-001',
            formattedName: 'Ada Lovelace, FRS',
            organization: 'Analytical Engines',
            emails: const [
              ContactEmail(value: 'ada@example.org', type: 'work'),
            ],
            phones: const [
              ContactPhone(value: '+44-20-7000-1815', type: 'cell'),
            ],
          ),
        );

        final stored = await (db.select(
          db.contactCards,
        )..where((t) => t.id.equals(id))).getSingle();
        expect(stored.formattedName, 'Ada Lovelace, FRS');
        // Round-trip preserves vendor X-* properties (audit dim 7).
        expect(stored.rawVcard.contains('X-IM-SLACK:'), isTrue);
        expect(stored.rawVcard.contains('X-CUSTOM-VENDOR-NOTE:'), isTrue);
        // FN was patched in place.
        expect(stored.rawVcard.contains('FN:Ada Lovelace, FRS'), isTrue);
        // Old EMAIL rows replaced, new TEL re-rendered.
        expect(
          stored.rawVcard.contains('EMAIL;TYPE=work:ada@example.org'),
          isTrue,
        );
      },
    );

    test(
      'deleteContact tombstones locally and queues delete with baseEtag',
      () async {
        final db = _db();
        addTearDown(db.close);
        final collectionId = await _seedAccountWithCollection(db);
        final repo = ContactRepository(db: db);

        final id = await repo.createContact(
          ContactDraft(collectionId: collectionId, formattedName: 'Doomed'),
        );
        await (db.update(db.contactCards)..where((t) => t.id.equals(id))).write(
          const ContactCardsCompanion(etag: Value('"server-etag-1"')),
        );

        await repo.deleteContact(id);

        final stored = await (db.select(
          db.contactCards,
        )..where((t) => t.id.equals(id))).getSingle();
        expect(stored.deletedLocally, isTrue);

        final pending = await (db.select(
          db.pendingChanges,
        )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
        expect(pending.last.operation, 'delete');
        expect(pending.last.baseEtag, '"server-etag-1"');
      },
    );
  });

  group('Groups + membership', () {
    test('createGroup, attach a contact, then delete the group', () async {
      final db = _db();
      addTearDown(db.close);
      final collectionId = await _seedAccountWithCollection(db);
      final repo = ContactRepository(db: db);

      final friendsId = await repo.createGroup(
        collectionId: collectionId,
        name: 'Friends',
      );
      final contactId = await repo.createContact(
        ContactDraft(
          collectionId: collectionId,
          formattedName: 'Bob',
          groupIds: [friendsId],
        ),
      );

      final memberships = await repo.membershipsOf(contactId);
      expect(memberships, hasLength(1));
      expect(memberships.first.groupId, friendsId);

      await repo.deleteGroup(friendsId);
      final groupsAfter = await repo.groupsIn(collectionId);
      expect(groupsAfter, isEmpty);
    });
  });

  group('Photo handling', () {
    test(
      'createContact with photoBase64 emits a data: URI PHOTO line',
      () async {
        final db = _db();
        addTearDown(db.close);
        final collectionId = await _seedAccountWithCollection(db);
        final repo = ContactRepository(db: db);

        final id = await repo.createContact(
          ContactDraft(
            collectionId: collectionId,
            formattedName: 'Picture-perfect',
            photoBase64: 'iVBORw0KGgoAAAANSUhEUg',
            photoMimeType: 'image/png',
          ),
        );
        final card = await (db.select(
          db.contactCards,
        )..where((t) => t.id.equals(id))).getSingle();
        expect(card.rawVcard.contains('PHOTO:data:image/png;base64,'), isTrue);
        // photoRef stores the base64 payload for the editor to surface.
        expect(card.photoRef, 'iVBORw0KGgoAAAANSUhEUg');
      },
    );

    test('createContact with photoUri emits a bare URI PHOTO line', () async {
      final db = _db();
      addTearDown(db.close);
      final collectionId = await _seedAccountWithCollection(db);
      final repo = ContactRepository(db: db);

      final id = await repo.createContact(
        ContactDraft(
          collectionId: collectionId,
          formattedName: 'Hosted',
          photoUri: 'https://example.org/portraits/ada.jpg',
        ),
      );
      final card = await (db.select(
        db.contactCards,
      )..where((t) => t.id.equals(id))).getSingle();
      expect(
        card.rawVcard.contains('PHOTO:https://example.org/portraits/ada.jpg'),
        isTrue,
      );
    });
  });

  group('Listing', () {
    test(
      'listContacts sorts by familyName, givenName, formattedName, hides tombstones',
      () async {
        final db = _db();
        addTearDown(db.close);
        final collectionId = await _seedAccountWithCollection(db);
        var n = 0;
        final repo = ContactRepository(
          db: db,
          uidGenerator: () => 'uid-${++n}',
        );

        final ids = <int>[];
        ids.add(
          await repo.createContact(
            ContactDraft(
              collectionId: collectionId,
              formattedName: 'Charlie Brown',
              familyName: 'Brown',
              givenName: 'Charlie',
            ),
          ),
        );
        ids.add(
          await repo.createContact(
            ContactDraft(
              collectionId: collectionId,
              formattedName: 'Ada Lovelace',
              familyName: 'Lovelace',
              givenName: 'Ada',
            ),
          ),
        );
        ids.add(
          await repo.createContact(
            ContactDraft(
              collectionId: collectionId,
              formattedName: 'Bob Brown',
              familyName: 'Brown',
              givenName: 'Bob',
            ),
          ),
        );
        await repo.deleteContact(ids[0]);

        final list = await repo.listContacts();
        expect(list.map((c) => c.formattedName), ['Bob Brown', 'Ada Lovelace']);
      },
    );
  });
}
