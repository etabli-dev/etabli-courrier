import 'package:drift/drift.dart';
import 'package:meta/meta.dart';

import '../db/database.dart';

// Cross-module search. M11 ships a SQL-fan-out implementation that hits the
// indexed snippet/title/summary columns directly. The result type carries a
// per-module label so the unified search screen can group hits.

enum SearchModule { calendar, contacts, tasks, notes, mail, feeds }

@immutable
class GlobalSearchHit {
  const GlobalSearchHit({
    required this.module,
    required this.title,
    required this.snippet,
    required this.targetId,
    this.subtitle,
    this.date,
  });

  final SearchModule module;
  final String title;
  final String snippet;

  /// The primary key of the row that surfaced the hit; the UI uses this +
  /// [module] to navigate into the right detail screen.
  final int targetId;

  final String? subtitle;
  final DateTime? date;
}

class GlobalSearchService {
  GlobalSearchService({required this.db});

  final CourrierDatabase db;

  Future<List<GlobalSearchHit>> search(
    String term, {
    int perModuleLimit = 20,
  }) async {
    if (term.trim().isEmpty) {
      return const <GlobalSearchHit>[];
    }
    final pattern = '%${term.toLowerCase().replaceAll(' ', '%')}%';

    final results = <GlobalSearchHit>[];
    results.addAll(await _searchCalendar(pattern, perModuleLimit));
    results.addAll(await _searchContacts(pattern, perModuleLimit));
    results.addAll(await _searchTasks(pattern, perModuleLimit));
    results.addAll(await _searchNotes(pattern, perModuleLimit));
    results.addAll(await _searchMail(pattern, perModuleLimit));
    results.addAll(await _searchFeeds(pattern, perModuleLimit));
    results.sort(_byDateDesc);
    return List<GlobalSearchHit>.unmodifiable(results);
  }

  int _byDateDesc(GlobalSearchHit a, GlobalSearchHit b) {
    final aDate = a.date;
    final bDate = b.date;
    if (aDate == null && bDate == null) {
      return 0;
    }
    if (aDate == null) {
      return 1;
    }
    if (bDate == null) {
      return -1;
    }
    return bDate.compareTo(aDate);
  }

  Future<List<GlobalSearchHit>> _searchCalendar(
    String pattern,
    int limit,
  ) async {
    final rows =
        await (db.select(db.calendarEvents)
              ..where(
                (t) =>
                    t.summary.lower().like(pattern) |
                    t.location.lower().like(pattern) |
                    t.description.lower().like(pattern),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.dtstart)])
              ..limit(limit))
            .get();
    return rows
        .map(
          (r) => GlobalSearchHit(
            module: SearchModule.calendar,
            targetId: r.id,
            title: r.summary ?? '(no title)',
            snippet: r.description ?? r.location ?? '',
            subtitle: r.location,
            date: r.dtstart,
          ),
        )
        .toList(growable: false);
  }

  Future<List<GlobalSearchHit>> _searchContacts(
    String pattern,
    int limit,
  ) async {
    final rows =
        await (db.select(db.contactCards)
              ..where(
                (t) =>
                    t.formattedName.lower().like(pattern) |
                    t.givenName.lower().like(pattern) |
                    t.familyName.lower().like(pattern) |
                    t.organization.lower().like(pattern) |
                    t.primaryEmail.lower().like(pattern),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.formattedName)])
              ..limit(limit))
            .get();
    return rows
        .map(
          (r) => GlobalSearchHit(
            module: SearchModule.contacts,
            targetId: r.id,
            title: r.formattedName ?? r.organization ?? '(no name)',
            snippet: r.primaryEmail ?? r.organization ?? '',
          ),
        )
        .toList(growable: false);
  }

  Future<List<GlobalSearchHit>> _searchTasks(String pattern, int limit) async {
    final rows =
        await (db.select(db.todoItems)
              ..where(
                (t) =>
                    t.summary.lower().like(pattern) |
                    t.description.lower().like(pattern),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.due)])
              ..limit(limit))
            .get();
    return rows
        .map(
          (r) => GlobalSearchHit(
            module: SearchModule.tasks,
            targetId: r.id,
            title: r.summary ?? '(no summary)',
            snippet: r.description ?? '',
            date: r.due,
          ),
        )
        .toList(growable: false);
  }

  Future<List<GlobalSearchHit>> _searchNotes(String pattern, int limit) async {
    final rows =
        await (db.select(db.noteItems)
              ..where(
                (t) =>
                    t.title.lower().like(pattern) |
                    t.content.lower().like(pattern),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.modified)])
              ..limit(limit))
            .get();
    return rows
        .map(
          (r) => GlobalSearchHit(
            module: SearchModule.notes,
            targetId: r.id,
            title: r.title,
            snippet: r.locked ? '(locked)' : r.content,
            date: r.modified,
          ),
        )
        .toList(growable: false);
  }

  Future<List<GlobalSearchHit>> _searchMail(String pattern, int limit) async {
    final rows =
        await (db.select(db.mailMessages)
              ..where(
                (t) =>
                    t.subject.lower().like(pattern) |
                    t.fromAddress.lower().like(pattern) |
                    t.snippet.lower().like(pattern) |
                    t.bodyText.lower().like(pattern),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.receivedAt)])
              ..limit(limit))
            .get();
    return rows
        .map(
          (r) => GlobalSearchHit(
            module: SearchModule.mail,
            targetId: r.id,
            title: r.subject ?? '(no subject)',
            snippet: r.snippet ?? '',
            subtitle: r.fromAddress,
            date: r.receivedAt,
          ),
        )
        .toList(growable: false);
  }

  Future<List<GlobalSearchHit>> _searchFeeds(String pattern, int limit) async {
    final rows =
        await (db.select(db.feedItems)
              ..where(
                (t) =>
                    t.title.lower().like(pattern) |
                    t.content.lower().like(pattern) |
                    t.author.lower().like(pattern),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.publishedAt)])
              ..limit(limit))
            .get();
    return rows
        .map(
          (r) => GlobalSearchHit(
            module: SearchModule.feeds,
            targetId: r.id,
            title: r.title,
            snippet: r.author ?? '',
            date: r.publishedAt,
          ),
        )
        .toList(growable: false);
  }
}
