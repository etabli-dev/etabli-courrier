import 'package:drift/native.dart';

import '../core/db/database.dart';
import '../modules/calendar/data/calendar_repository.dart';
import '../modules/calendar/data/event_draft.dart';
import '../modules/contacts/data/contact_draft.dart';
import '../modules/contacts/data/contact_repository.dart';
import '../modules/feeds/data/feed_repository.dart';
import '../modules/mail/backend/demo_mail_backend.dart';
import '../modules/mail/backend/mail_credentials.dart';
import '../modules/mail/data/mail_repository.dart';
import '../modules/notes/data/note_draft.dart';
import '../modules/notes/data/note_repository.dart';
import '../modules/tasks/data/task_draft.dart';
import '../modules/tasks/data/task_repository.dart';

// Demo wiring used by M13 Maestro flows and M14 sample-content fixtures.
//
// Builds an in-memory CourrierDatabase, seeds one local account + one
// collection per module + a realistic per-module sample set, and surfaces
// the wired repositories so the demo shell can route screens into known
// states for screenshot capture.

class DemoServices {
  DemoServices._({
    required this.db,
    required this.calendar,
    required this.contacts,
    required this.tasks,
    required this.notes,
    required this.mail,
    required this.feeds,
  });

  final CourrierDatabase db;
  final CalendarRepository calendar;
  final ContactRepository contacts;
  final TaskRepository tasks;
  final NoteRepository notes;
  final MailRepository mail;
  final FeedRepository feeds;

  static Future<DemoServices> bootInMemory() async {
    final db = CourrierDatabase.forTesting(NativeDatabase.memory());

    // One local account is enough for screenshot capture.
    final accountId = await db
        .into(db.accounts)
        .insert(
          AccountsCompanion.insert(kind: 'local', displayName: 'Demo account'),
        );

    final calendarCollectionId = await db
        .into(db.collections)
        .insert(
          CollectionsCompanion.insert(
            accountId: accountId,
            kind: 'calendar',
            displayName: 'Personal',
          ),
        );
    final contactsCollectionId = await db
        .into(db.collections)
        .insert(
          CollectionsCompanion.insert(
            accountId: accountId,
            kind: 'contacts',
            displayName: 'Address book',
          ),
        );
    final tasksCollectionId = await db
        .into(db.collections)
        .insert(
          CollectionsCompanion.insert(
            accountId: accountId,
            kind: 'tasks',
            displayName: 'Today',
          ),
        );
    final notesCollectionId = await db
        .into(db.collections)
        .insert(
          CollectionsCompanion.insert(
            accountId: accountId,
            kind: 'notes',
            displayName: 'Notes',
          ),
        );

    final calendar = CalendarRepository(db: db);
    final contacts = ContactRepository(db: db);
    final tasks = TaskRepository(db: db);
    final notes = NoteRepository(db: db);

    await _seedCalendar(calendar, calendarCollectionId);
    await _seedContacts(contacts, contactsCollectionId);
    await _seedTasks(tasks, tasksCollectionId);
    await _seedNotes(notes, notesCollectionId);

    // Mail goes through the canonical DemoMailBackend (3-message thread,
    // remote-img newsletter, attachment, etc — see M6).
    final mailBackend = DemoMailBackend();
    await mailBackend.connect(
      const PasswordCredentials(
        username: 'demo@etabli.dev',
        password: 'placeholder',
      ),
    );
    final mail = MailRepository(
      db: db,
      backend: mailBackend,
      accountId: accountId,
    );
    await mail.syncFolders();
    await mail.syncEnvelopes(folderName: 'INBOX');

    final feeds = FeedRepository(db: db, accountId: accountId);
    await _seedFeeds(feeds);

    return DemoServices._(
      db: db,
      calendar: calendar,
      contacts: contacts,
      tasks: tasks,
      notes: notes,
      mail: mail,
      feeds: feeds,
    );
  }

  static Future<void> _seedCalendar(
    CalendarRepository repo,
    int collectionId,
  ) async {
    final now = DateTime.now();
    DateTime atToday(int hour) => DateTime(now.year, now.month, now.day, hour);
    DateTime atOffset(int days, int hour) =>
        DateTime(now.year, now.month, now.day + days, hour);

    await repo.createEvent(
      EventDraft(
        collectionId: collectionId,
        summary: 'Weekly status',
        start: atToday(10),
        end: atToday(11),
        rrule: 'FREQ=WEEKLY;BYDAY=MO',
        location: 'Room 314',
        organizer: 'mailto:lead@etabli.dev',
        attendees: const ['mailto:alice@etabli.dev', 'mailto:bob@etabli.dev'],
      ),
    );
    await repo.createEvent(
      EventDraft(
        collectionId: collectionId,
        summary: 'Coffee with Ada',
        start: atOffset(1, 9),
        end: atOffset(1, 10),
      ),
    );
    await repo.createEvent(
      EventDraft(
        collectionId: collectionId,
        summary: 'Quarterly review',
        start: atOffset(3, 14),
        end: atOffset(3, 16),
        location: 'Conference Room A',
      ),
    );
  }

  static Future<void> _seedContacts(
    ContactRepository repo,
    int collectionId,
  ) async {
    Future<void> create({
      required String fn,
      required String given,
      required String family,
      String? org,
      String? email,
      String? phone,
    }) => repo.createContact(
      ContactDraft(
        collectionId: collectionId,
        formattedName: fn,
        givenName: given,
        familyName: family,
        organization: org,
        emails: email == null ? const [] : [ContactEmail(value: email)],
        phones: phone == null ? const [] : [ContactPhone(value: phone)],
      ),
    );

    await create(
      fn: 'Ada Lovelace',
      given: 'Ada',
      family: 'Lovelace',
      org: 'Analytical Engines',
      email: 'ada@example.org',
      phone: '+44-20-7000-1815',
    );
    await create(
      fn: 'Grace Hopper',
      given: 'Grace',
      family: 'Hopper',
      org: 'Bell Labs',
      email: 'grace@example.org',
    );
    await create(
      fn: 'Bob Brown',
      given: 'Bob',
      family: 'Brown',
      email: 'bob@example.org',
    );
  }

  static Future<void> _seedTasks(TaskRepository repo, int collectionId) async {
    await repo.createTask(
      TaskDraft(
        collectionId: collectionId,
        summary: 'Ship M13 screenshots',
        due: DateTime.now().add(const Duration(days: 1)),
        priority: 5,
        percentComplete: 60,
      ),
    );
    await repo.createTask(
      TaskDraft(
        collectionId: collectionId,
        summary: 'Buy stamps',
        due: DateTime.now().add(const Duration(days: 3)),
      ),
    );
    await repo.createTask(
      TaskDraft(
        collectionId: collectionId,
        summary: 'Weekly review',
        due: DateTime.now().add(const Duration(days: 7)),
        rrule: 'FREQ=WEEKLY;INTERVAL=1',
        repeatAfterCompletion: true,
      ),
    );
  }

  static Future<void> _seedNotes(NoteRepository repo, int collectionId) async {
    await repo.createNote(
      NoteDraft(
        collectionId: collectionId,
        title: 'Shopping list',
        content: '- [ ] milk\n- [x] eggs\n- [ ] coffee',
        kind: NoteKind.checklist,
        favorite: true,
      ),
    );
    await repo.createNote(
      NoteDraft(
        collectionId: collectionId,
        title: 'Release notes draft',
        content:
            'courrier v0.1.0 launches with seven offline-first modules ...',
      ),
    );
    await repo.createNote(
      NoteDraft(
        collectionId: collectionId,
        title: 'Personal',
        content: 'Confidential note body.',
        locked: true,
      ),
    );
  }

  static Future<void> _seedFeeds(FeedRepository repo) async {
    final blog = await repo.subscribe(
      url: 'https://example.org/blog',
      title: 'Example Tech Blog',
      folder: 'Tech',
    );
    await repo.upsertItem(
      feedId: blog,
      guid: 'first',
      title: 'Hello, RSS',
      author: 'Ada Lovelace',
      content: 'Full content with some markup.',
      publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
    );
    await repo.upsertItem(
      feedId: blog,
      guid: 'second',
      title: 'Second post',
      content: 'Quick follow-up.',
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
    );
    final news = await repo.subscribe(
      url: 'https://news.example.org/atom',
      title: 'Example News',
    );
    await repo.upsertItem(
      feedId: news,
      guid: 'news-1',
      title: 'Industry roundup',
      author: 'News desk',
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
    );
  }
}
