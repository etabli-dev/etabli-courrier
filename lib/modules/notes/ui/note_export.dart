import 'dart:convert';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../../../core/db/database.dart';
import '../data/note_contribution.dart';

Future<void> exportCheckedNote(
  BuildContext context,
  CourrierDatabase db,
  NoteItem note,
) async {
  final file = await openFile(
    acceptedTypeGroups: [
      const XTypeGroup(
        label: 'Notes events',
        extensions: ['json'],
        uniformTypeIdentifiers: ['public.json'],
      ),
    ],
  );
  if (file == null || !context.mounted) return;
  if (await file.length() > 4 * 1024 * 1024) {
    throw const FormatException('Event file too large');
  }
  final data = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  if (!context.mounted) return;
  Map<String, dynamic>? target = data;
  if (data['schema'] == 'notes-manifest/1') {
    final events = (data['events'] as List).cast<Map<String, dynamic>>();
    target = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (c) => SimpleDialog(
        title: const Text('Notes event'),
        children: [
          for (final e in events)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(c, e),
              child: Text(
                '${e['title'] ?? ''}\n${e['occurred_at'] ?? e['occurrence_start']}',
              ),
            ),
        ],
      ),
    );
  }
  if (target == null || !context.mounted) return;
  final controller = TextEditingController(text: note.content);
  final approved = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('Review short note'),
      content: SizedBox(
        width: 600,
        child: TextField(
          controller: controller,
          maxLines: 12,
          decoration: const InputDecoration(
            helperText:
                'Keep only checked facts. Original documents stay in their source app.',
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(c, true),
          child: const Text('Checked — export'),
        ),
      ],
    ),
  );
  final summary = controller.text;
  controller.dispose();
  if (approved != true) return;
  final result = await exportNoteContribution(db, note, target, summary);
  final location = await getSaveLocation(suggestedName: result.filename);
  if (location == null) return;
  await XFile.fromData(
    Uint8List.fromList(utf8.encode(result.json)),
    mimeType: 'application/json',
    name: result.filename,
  ).saveTo(location.path);
}
