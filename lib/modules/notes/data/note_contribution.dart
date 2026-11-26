import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';

import '../../../core/db/database.dart';

String canonicalNoteJson(Object? value) {
  if (value is Map<String, Object?>) {
    final keys = value.keys.toList()..sort();
    return '{${keys.map((k) => '${jsonEncode(k)}:${canonicalNoteJson(value[k])}').join(',')}}';
  }
  if (value is List) {
    return '[${value.map(canonicalNoteJson).join(',')}]';
  }
  return jsonEncode(value);
}

/// Immutable source revisions. Export never changes Nextcloud content or sync state.
Future<({String filename, String json})> exportNoteContribution(
  CourrierDatabase db,
  NoteItem note,
  Map<String, dynamic> target,
  String checkedSummary,
) async {
  const identityKeys = [
    'note_id',
    'calendar_id',
    'event_uid',
    'occurrence_start',
  ];
  for (final key in identityKeys) {
    if (target[key] is! String || (target[key] as String).isEmpty) {
      throw const FormatException('Invalid event identity');
    }
  }
  if (!RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      ).hasMatch(target['note_id'] as String) ||
      !RegExp(
        r'(Z|[+-]\d\d:\d\d)$',
      ).hasMatch(target['occurrence_start'] as String)) {
    throw const FormatException('Invalid event identity or timezone');
  }
  DateTime.parse(target['occurrence_start'] as String);
  if (checkedSummary.trim().isEmpty ||
      checkedSummary.runes.length > 12000 ||
      note.title.trim().isEmpty ||
      note.title.runes.length > 300 ||
      checkedSummary.toLowerCase().contains('base64,')) {
    throw const FormatException('A short checked text summary is required');
  }
  return db.transaction(() async {
    await db.customStatement(
      'CREATE TABLE IF NOT EXISTS notes_export_state (local_id INTEGER PRIMARY KEY, item_id TEXT NOT NULL, payload TEXT NOT NULL, revision INTEGER NOT NULL)',
    );
    final row = await db
        .customSelect(
          'SELECT * FROM notes_export_state WHERE local_id=?',
          variables: [Variable(note.id)],
        )
        .getSingleOrNull();
    final item =
        row?.read<String>('item_id') ??
        List.generate(
          16,
          (_) => Random.secure().nextInt(256).toRadixString(16).padLeft(2, '0'),
        ).join();
    final revision = (row?.read<int>('revision') ?? 0) + 1;
    final body = <String, Object?>{
      'schema': 'notes-contribution/1',
      'note_id': target['note_id'],
      'event': {for (final k in identityKeys.skip(1)) k: target[k]},
      'source': {'name': 'Courrier', 'item_id': item, 'revision': revision},
      'occurred_at':
          target['occurred_at'] ?? note.modified.toUtc().toIso8601String(),
      'created_at': note.modified.toUtc().toIso8601String(),
      'title': note.title,
      'participants': <String>[],
      'project': null,
      'content': {
        'summary': checkedSummary.trim(),
        'decisions': <Object>[],
        'tasks': <Object>[],
        'open_questions': <String>[],
      },
      'processing': {'engine': 'courrier-human-review', 'incomplete': false},
      'review': {'status': 'reviewed'},
    };
    if (row != null) {
      final previous =
          jsonDecode(row.read<String>('payload')) as Map<String, dynamic>;
      if (previous['note_id'] != body['note_id'] ||
          canonicalNoteJson(previous['event']) !=
              canonicalNoteJson(body['event'])) {
        throw StateError(
          'An exported note cannot silently move to another event',
        );
      }
      final candidate = {...body, 'source': previous['source']};
      final old = {...previous}..remove('content_sha256');
      if (canonicalNoteJson(candidate) == canonicalNoteJson(old)) {
        return (
          filename:
              '${body['note_id']}__Courrier__${item}__r${row.read<int>('revision').toString().padLeft(4, '0')}.json',
          json: row.read<String>('payload'),
        );
      }
    }
    body['content_sha256'] = sha256
        .convert(utf8.encode(canonicalNoteJson(body)))
        .toString();
    final encoded = canonicalNoteJson(body);
    await db.customStatement(
      'INSERT OR REPLACE INTO notes_export_state VALUES(?,?,?,?)',
      [note.id, item, encoded, revision],
    );
    return (
      filename:
          '${body['note_id']}__Courrier__${item}__r${revision.toString().padLeft(4, '0')}.json',
      json: encoded,
    );
  });
}
