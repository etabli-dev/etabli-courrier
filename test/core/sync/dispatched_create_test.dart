import 'dart:async';
import 'package:courrier/core/db/database.dart';
import 'package:courrier/core/net/dav/dav_client.dart';
import 'package:courrier/modules/notes/data/note_draft.dart';
import 'package:courrier/modules/notes/data/note_repository.dart';
import 'package:courrier/modules/notes/sync/nextcloud_notes_client.dart';
import 'package:courrier/modules/notes/sync/notes_sync_backend.dart';
import 'package:courrier/modules/tasks/data/task_draft.dart';
import 'package:courrier/modules/tasks/data/task_repository.dart';
import 'package:courrier/modules/tasks/sync/tasks_sync_backend.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late CourrierDatabase db;
  late int account;
  setUp(() async {
    db = CourrierDatabase.forTesting(NativeDatabase.memory());
    account = await db
        .into(db.accounts)
        .insert(
          AccountsCompanion.insert(kind: 'nextcloud', displayName: 'Cloud'),
        );
  });
  tearDown(() => db.close());
  test(
    'lost POST response plus a concurrent edit does not trigger a duplicate create',
    () async {
      final collection = await db
          .into(db.collections)
          .insert(
            CollectionsCompanion.insert(
              accountId: account,
              kind: 'notes',
              displayName: 'Notes',
            ),
          );
      final repo = NoteRepository(db: db);
      final draft = NoteDraft(
        collectionId: collection,
        title: 'Draft',
        content: 'first',
      );
      final id = await repo.createNote(draft);
      final entered = Completer<void>();
      final response = Completer<http.Response>();
      var posts = 0;
      final client = NextcloudNotesClient(
        baseUrl: Uri.parse('https://cloud.example.org/'),
        credentials: const DavCredentials(username: 'u', password: 'p'),
        httpClient: MockClient((request) async {
          expect(request.method, 'POST');
          posts++;
          entered.complete();
          return response.future;
        }),
      );
      addTearDown(client.close);
      final backend = NotesSyncBackend(db: db, client: client);
      final pass = backend.push(accountId: account);
      await entered.future;
      await repo.updateNote(id, draft.copyWith(content: 'second'));
      response.complete(http.Response('unavailable', 503));
      expect((await pass).success, isFalse);
      expect((await backend.push(accountId: account)).success, isFalse);
      expect(posts, 1);
      expect((await repo.findById(id))!.content, 'second');
      expect(
        (await db.select(db.pendingChanges).getSingle()).attempts,
        greaterThan(0),
      );
    },
  );
  test(
    'edit during successful DAV creation follows with conditional update, not a second create',
    () async {
      final collection = await db
          .into(db.collections)
          .insert(
            CollectionsCompanion.insert(
              accountId: account,
              kind: 'tasks',
              displayName: 'Tasks',
            ),
          );
      final repo = TaskRepository(db: db, uidGenerator: () => 'one-task');
      final id = await repo.createTask(
        TaskDraft(collectionId: collection, summary: 'First'),
      );
      final entered = Completer<void>();
      final response = Completer<http.Response>();
      var puts = 0;
      final dav = DavClient(
        credentials: const DavCredentials(username: 'u', password: 'p'),
        httpClient: MockClient((request) async {
          expect(request.method, 'PUT');
          puts++;
          if (puts == 1) {
            expect(request.headers['if-none-match'], '*');
            entered.complete();
            return response.future;
          }
          expect(request.headers['if-match'], '"e1"');
          expect(request.headers.containsKey('if-none-match'), isFalse);
          expect(request.body, contains('SUMMARY:Second'));
          return http.Response('', 204, headers: {'etag': '"e2"'});
        }),
      );
      addTearDown(dav.close);
      final backend = TasksSyncBackend(
        db: db,
        davClient: dav,
        collectionUrlResolver: (_) =>
            Uri.parse('https://cloud.example.org/tasks/'),
      );
      final pass = backend.push(accountId: account);
      await entered.future;
      await repo.updateTask(
        id,
        TaskDraft(collectionId: collection, summary: 'Second'),
      );
      response.complete(http.Response('', 201, headers: {'etag': '"e1"'}));
      expect((await pass).success, isTrue);
      expect((await backend.push(accountId: account)).success, isTrue);
      expect(puts, 2);
      expect(await db.select(db.pendingChanges).get(), isEmpty);
      expect((await db.select(db.todoItems).getSingle()).summary, 'Second');
    },
  );
}
