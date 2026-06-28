import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import '../../modules/calendar/import/ics_importer.dart';
import '../../modules/feeds/data/feed_repository.dart';
import '../../modules/notes/data/note_draft.dart';
import '../../modules/notes/data/note_repository.dart';
import '../db/database.dart';

// Sample-content installer (M14). Runs on first launch when no accounts
// exist in the database. Idempotent — if any account is present, every call
// is a no-op so existing users never see surprise rows.
//
// What it seeds:
//   * one `local`-kind account ("Local sample content")
//   * a "Holidays 2026" local-only calendar with the bundled ICS imported
//     via the M3 IcsImporter
//   * a "Welcome" local notes collection with two starter notes
//   * a sample RSS subscription for the courrier project blog so the Feeds
//     tab shows a row even before the user adds their own
//
// Production users can wipe everything from Settings → Reset; the next
// launch re-seeds (the welcome state is part of the product). A future
// "starter content" preference toggle (M11 polish) suppresses the re-install.

class SampleContentInstaller {
  const SampleContentInstaller({this.bundle});

  /// Optional override so tests can drop a deterministic in-memory bundle.
  final AssetBundle? bundle;

  static const String holidaysAssetPath = 'assets/sample/holidays_2026.ics';

  Future<bool> installIfMissing(CourrierDatabase db) async {
    final accounts = await db.select(db.accounts).get();
    if (accounts.isNotEmpty) {
      return false;
    }
    await _install(db);
    return true;
  }

  Future<void> _install(CourrierDatabase db) async {
    final accountId = await db
        .into(db.accounts)
        .insert(
          AccountsCompanion.insert(
            kind: 'local',
            displayName: 'Local sample content',
          ),
        );

    // Holidays calendar — bundled ICS imported via the M3 importer.
    final calendarCollectionId = await db
        .into(db.collections)
        .insert(
          CollectionsCompanion.insert(
            accountId: accountId,
            kind: 'calendar',
            displayName: 'Holidays 2026',
          ),
        );
    final source = await (bundle ?? rootBundle).loadString(holidaysAssetPath);
    await IcsImporter(
      db: db,
    ).importVcalendar(collectionId: calendarCollectionId, contents: source);

    // Welcome notes — two starter rows so the Notes tab isn't empty on day 1.
    final notesCollectionId = await db
        .into(db.collections)
        .insert(
          CollectionsCompanion.insert(
            accountId: accountId,
            kind: 'notes',
            displayName: 'Welcome',
          ),
        );
    final notes = NoteRepository(db: db);
    await notes.createNote(
      NoteDraft(
        collectionId: notesCollectionId,
        title: 'Getting started',
        content:
            'Tap Settings → Accounts to connect your Nextcloud, email, '
            'or Microsoft 365 mailbox. Everything in courrier works offline '
            'first — sync is optional.',
        favorite: true,
      ),
    );
    await notes.createNote(
      NoteDraft(
        collectionId: notesCollectionId,
        title: 'Checklist demo',
        content:
            '- [ ] Try the mail demo\n'
            '- [x] Read the welcome note\n'
            '- [ ] Connect a real account from Settings',
        kind: NoteKind.checklist,
      ),
    );

    // Sample feed — points at the courrier project blog. The first sync
    // pulls in the real items; until then the title alone tells the user
    // the Feeds module is wired.
    final feeds = FeedRepository(db: db, accountId: accountId);
    await feeds.subscribe(
      url: 'https://etabli.dev/courrier/feed.xml',
      title: 'courrier release notes',
      folder: 'Suite',
    );
  }
}
