import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import '../../core/db/database.dart';
import '../../core/lock/app_security.dart';
import '../../core/sync/conflict_recovery.dart';
import '../../l10n/l10n.dart';

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
    final l10n = context.l10n;
    final approved = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.accountsPreserveTitle),
        content: Text(l10n.accountsPreserveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(l10n.accountsKeepOfflineCopy),
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
          SnackBar(content: Text(context.l10n.accountsPreserveFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.accountsPendingTitle)),
    body: StreamBuilder<List<PendingChange>>(
      stream: _pending,
      builder: (context, snapshot) {
        final l10n = context.l10n;
        if (snapshot.hasError) {
          return Center(child: Text(l10n.accountsPendingReadFailed));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.isEmpty) {
          return Center(child: Text(l10n.accountsNoPendingEdits));
        }
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.accountsPendingIntro),
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
                          'note_items' => l10n.accountsRecordNote,
                          'todo_items' => l10n.accountsRecordTask,
                          'calendar_events' => l10n.accountsRecordEvent,
                          'contact_cards' => l10n.accountsRecordContact,
                          _ => l10n.accountsRecordOther,
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
                              title: Text(l10n.accountsSavedEditTitle),
                              content: SingleChildScrollView(
                                child: SelectableText(
                                  edit.payload ?? l10n.accountsDeletionIntent,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(c),
                                  child: Text(l10n.commonClose),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(l10n.accountsReviewEdit),
                      ),
                      TextButton(
                        onPressed: _busy ? null : () => _archive(edit),
                        child: Text(l10n.accountsKeepOfflineReload),
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
