import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import '../../core/db/database.dart';
import '../../core/lock/app_security.dart';
import '../../core/sync/conflict_recovery.dart';

class PendingEditsScreen extends StatefulWidget {
  const PendingEditsScreen({
    required this.db,
    required this.accountId,
    super.key,
  });
  final CourrierDatabase db;
  final int accountId;
  @override
  State<PendingEditsScreen> createState() => _PendingEditsScreenState();
}

class _PendingEditsScreenState extends State<PendingEditsScreen> {
  late final _pending =
      (widget.db.select(widget.db.pendingChanges)
            ..where((t) => t.accountId.equals(widget.accountId))
            ..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .watch();
  bool _busy = false;
  Future<void> _archive(PendingChange edit) async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Preserve this edit offline?'),
        content: const Text(
          'The current local record will move to an offline collection, including a locally deleted record. Its upload will stop. The server is unchanged. Return to Accounts and Refresh to load the server version separately. A server write whose response was lost may already exist there.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Keep offline copy'),
          ),
        ],
      ),
    );
    if (approved != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await archivePendingEdit(widget.db, edit.id);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not preserve this version. Nothing was discarded; refresh the list and retry.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Pending edits')),
    body: StreamBuilder<List<PendingChange>>(
      stream: _pending,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Could not read pending edits.'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No pending edits. Return to Accounts to refresh.'),
          );
        }
        return ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Refresh normally retries pending work with its original server precondition. If it cannot be reconciled, preserve the local record offline before reloading the server.',
              ),
            ),
            for (final edit in snapshot.data!)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${switch (edit.entityTable) {
                          'note_items' => 'Note',
                          'todo_items' => 'Task',
                          'calendar_events' => 'Event',
                          'contact_cards' => 'Contact',
                          _ => 'Record',
                        }} · ${edit.operation} · ${edit.entityId}',
                      ),
                      if (edit.lastError != null) Text(edit.lastError!),
                      TextButton(
                        onPressed: () async {
                          if (edit.entityTable == 'note_items') {
                            final note =
                                await (widget.db.select(
                                      widget.db.noteItems,
                                    )..where((t) => t.id.equals(edit.entityId)))
                                    .getSingleOrNull();
                            if (note?.locked == true &&
                                !await AppSecurity.unlock()) {
                              return;
                            }
                          }
                          if (!context.mounted) return;
                          await showDialog<void>(
                            context: context,
                            builder: (c) => AlertDialog(
                              title: const Text('Saved local edit'),
                              content: SingleChildScrollView(
                                child: SelectableText(
                                  edit.payload ??
                                      'Deletion intent; the original record is retained.',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(c),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Review saved local edit'),
                      ),
                      TextButton(
                        onPressed: _busy ? null : () => _archive(edit),
                        child: const Text('Keep offline copy; reload server'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    ),
  );
}
