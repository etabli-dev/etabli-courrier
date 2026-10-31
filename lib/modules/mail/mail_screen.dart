import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';

import '../../core/db/database.dart';
import 'backend/mail_backend.dart';
import 'data/mail_repository.dart';
import 'render/mime_render_plan.dart';
import 'ui/message_view.dart';
import 'ui/thread_list_view.dart';

/// Reads the persistent cache without opening a network connection on navigation.
class MailScreen extends StatefulWidget {
  const MailScreen({required this.db, this.downloadMessage, super.key});
  final Future<MailMessage> Function(MailMessage)? downloadMessage;
  final CourrierDatabase db;

  @override
  State<MailScreen> createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen> {
  late final _folders = widget.db.select(widget.db.mailFolders).watch();
  MailFolder? _selected;
  Stream<List<MailMessage>>? _messages;

  void _select(MailFolder folder) {
    setState(() {
      _selected = folder;
      _messages =
          (widget.db.select(widget.db.mailMessages)
                ..where((t) => t.folderId.equals(folder.id))
                ..orderBy([(t) => OrderingTerm.asc(t.receivedAt)]))
              .watch();
    });
  }

  Future<void> _open(MailThread thread) async {
    var message = thread.latest;
    try {
      if (!message.bodyDownloaded && widget.downloadMessage != null) {
        message = await widget.downloadMessage!(message);
      }
      final attachments = await (widget.db.select(
        widget.db.mailAttachments,
      )..where((t) => t.messageId.equals(message.id))).get();
      if (!mounted) return;
      final plan = const MimeRenderer().plan(
        MailBodyPayload(
          textPart: message.bodyDownloaded
              ? message.bodyText
              : 'This message body has not been downloaded. Connect the account and sync this folder to read it offline.',
          htmlPart: message.bodyHtml,
          attachments: attachments
              .map(
                (a) => MailAttachmentInfo(
                  filename: a.filename,
                  mimeType: a.mimeType,
                  sizeBytes: a.sizeBytes,
                  contentId: a.contentId,
                ),
              )
              .toList(),
        ),
      );
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text(message.subject ?? 'Message')),
            body: MessageView(message: message, plan: plan),
          ),
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open this message. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<List<MailFolder>>(
    stream: _folders,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Center(child: Text('Could not load mail folders.'));
      }
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      final folders = snapshot.data!;
      if (_selected == null || !folders.any((f) => f.id == _selected!.id)) {
        if (folders.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'No cached mail yet. Add an email account in Accounts, then sync its folders.',
              ),
            ),
          );
        }
        return ListView(
          children: [
            for (final folder in folders)
              ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: Text(folder.name),
                subtitle: Text('Account ${folder.accountId}'),
                onTap: () => _select(folder),
              ),
          ],
        );
      }
      return Column(
        children: [
          ListTile(
            leading: IconButton(
              tooltip: 'All folders',
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() => _selected = null),
            ),
            title: Text(_selected!.name),
          ),
          Expanded(
            child: StreamBuilder<List<MailMessage>>(
              stream: _messages,
              builder: (context, messages) {
                if (messages.hasError) {
                  return const Center(child: Text('Could not load messages.'));
                }
                if (!messages.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ThreadListView(
                  threads: MailRepository.groupIntoThreads(messages.data!),
                  onThreadTap: _open,
                );
              },
            ),
          ),
        ],
      );
    },
  );
}
