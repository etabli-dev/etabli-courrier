import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../compose/compose_draft.dart';

class ComposeView extends StatefulWidget {
  const ComposeView({
    required this.initialDraft,
    required this.onSend,
    this.onSaveDraft,
    this.onCancel,
    super.key,
  });

  final ComposeDraft initialDraft;
  final Future<void> Function(ComposeDraft draft) onSend;
  final Future<void> Function(ComposeDraft draft)? onSaveDraft;
  final VoidCallback? onCancel;

  @override
  State<ComposeView> createState() => _ComposeViewState();
}

class _ComposeViewState extends State<ComposeView> {
  late TextEditingController _to;
  late TextEditingController _cc;
  late TextEditingController _bcc;
  late TextEditingController _subject;
  late TextEditingController _body;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    final draft = widget.initialDraft;
    _to = TextEditingController(text: draft.toAddresses.join(', '));
    _cc = TextEditingController(text: draft.ccAddresses.join(', '));
    _bcc = TextEditingController(text: draft.bccAddresses.join(', '));
    _subject = TextEditingController(text: draft.subject ?? '');
    _body = TextEditingController(text: draft.bodyText ?? '');
  }

  @override
  void dispose() {
    _to.dispose();
    _cc.dispose();
    _bcc.dispose();
    _subject.dispose();
    _body.dispose();
    super.dispose();
  }

  ComposeDraft _currentDraft() {
    return widget.initialDraft.copyWith(
      toAddresses: _splitAddresses(_to.text),
      ccAddresses: _splitAddresses(_cc.text),
      bccAddresses: _splitAddresses(_bcc.text),
      subject: _subject.text.trim().isEmpty ? null : _subject.text.trim(),
      bodyText: _body.text,
    );
  }

  List<String> _splitAddresses(String value) {
    return value
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(CourrierTokens.space5),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _to,
              decoration: const InputDecoration(
                labelText: 'To',
                hintText: 'comma-separated',
              ),
            ),
            const SizedBox(height: CourrierTokens.space3),
            TextField(
              controller: _cc,
              decoration: const InputDecoration(labelText: 'Cc'),
            ),
            const SizedBox(height: CourrierTokens.space3),
            TextField(
              controller: _bcc,
              decoration: const InputDecoration(labelText: 'Bcc'),
            ),
            const SizedBox(height: CourrierTokens.space3),
            TextField(
              controller: _subject,
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
            const SizedBox(height: CourrierTokens.space3),
            TextField(
              controller: _body,
              decoration: const InputDecoration(labelText: 'Body'),
              minLines: 6,
              maxLines: 16,
            ),
            const SizedBox(height: CourrierTokens.space5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.onCancel != null)
                  TextButton(
                    onPressed: _sending ? null : widget.onCancel,
                    child: const Text('Cancel'),
                  ),
                if (widget.onSaveDraft != null)
                  TextButton(
                    onPressed: _sending
                        ? null
                        : () async {
                            await widget.onSaveDraft!(_currentDraft());
                          },
                    child: const Text('Save draft'),
                  ),
                const SizedBox(width: CourrierTokens.space2),
                FilledButton(
                  onPressed: _sending
                      ? null
                      : () async {
                          setState(() => _sending = true);
                          try {
                            await widget.onSend(_currentDraft());
                          } finally {
                            if (mounted) {
                              setState(() => _sending = false);
                            }
                          }
                        },
                  child: Text(_sending ? 'Sending…' : 'Send'),
                ),
              ],
            ),
            const SizedBox(height: CourrierTokens.space3),
            Text(
              'Plain text only. Attachments + HTML composition land at M11 polish.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
