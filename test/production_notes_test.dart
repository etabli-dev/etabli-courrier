import 'package:courrier/core/db/database.dart';
import 'package:courrier/main.dart';
import 'package:courrier/modules/notes/data/note_draft.dart';
import 'package:courrier/modules/notes/data/note_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late CourrierDatabase db;
  late NoteRepository notes;
  late int collection;
  var closed = false;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/local_auth'),
          (_) async => false,
        );
    closed = false;
    db = CourrierDatabase.forTesting(NativeDatabase.memory());
    notes = NoteRepository(db: db);
    final account = await db
        .into(db.accounts)
        .insert(AccountsCompanion.insert(kind: 'local', displayName: 'Local'));
    collection = await db
        .into(db.collections)
        .insert(
          CollectionsCompanion.insert(
            accountId: account,
            kind: 'notes',
            displayName: 'Notebook',
          ),
        );
  });
  tearDown(() async {
    if (!closed) await db.close();
  });

  testWidgets('normal phone launch opens, edits and persists a note', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final id = await notes.createNote(
      NoteDraft(
        collectionId: collection,
        title: 'Welcome',
        content: 'Original text',
      ),
    );
    await tester.pumpWidget(CourrierApp(database: db));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.notes).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Welcome'));
    await tester.pumpAndSettle();
    expect(find.text('Edit note'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.enterText(
      find.widgetWithText(TextField, 'Original text'),
      'Saved offline',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect((await notes.findById(id))!.content, 'Saved offline');
    expect(find.text('Saved offline'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await db.close();
    closed = true;
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a locked note never exposes its body without authentication', (
    tester,
  ) async {
    await notes.createNote(
      NoteDraft(
        collectionId: collection,
        title: 'Locked',
        content: 'Private body',
        locked: true,
      ),
    );
    await tester.pumpWidget(CourrierApp(database: db));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.notes).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Locked'));
    await tester.pumpAndSettle();
    expect(find.text('Private body'), findsNothing);
    expect(find.text('Unlock is required to open this note.'), findsOneWidget);
    await db.close();
    closed = true;
    await tester.pumpWidget(const SizedBox());
  });

  test(
    'note and sync intent roll back together when the queue cannot be written',
    () async {
      final id = await notes.createNote(
        NoteDraft(
          collectionId: collection,
          title: 'Preserve',
          content: 'Original',
        ),
      );
      await db.customStatement(
        "CREATE TRIGGER fail_queue BEFORE INSERT ON pending_changes BEGIN SELECT RAISE(ABORT, 'queue unavailable'); END",
      );
      await expectLater(
        notes.updateNote(
          id,
          NoteDraft(collectionId: collection, title: 'Changed', content: 'New'),
        ),
        throwsA(anything),
      );
      expect((await notes.findById(id))!.content, 'Original');
      await expectLater(notes.deleteNote(id), throwsA(anything));
      expect((await notes.findById(id))!.deletedLocally, isFalse);
      expect(await notes.listNotes(), hasLength(1));
    },
  );
}
