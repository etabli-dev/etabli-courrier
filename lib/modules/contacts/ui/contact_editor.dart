import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../data/contact_draft.dart';

class ContactEditor extends StatefulWidget {
  const ContactEditor({
    required this.initialDraft,
    required this.onSave,
    this.onCancel,
    this.availableGroups = const <ContactGroupRef>[],
    super.key,
  });

  final ContactDraft initialDraft;
  final Future<void> Function(ContactDraft draft) onSave;
  final VoidCallback? onCancel;

  /// Group rows the user can attach/detach. M11 polish wires the actual list.
  final List<ContactGroupRef> availableGroups;

  @override
  State<ContactEditor> createState() => _ContactEditorState();
}

class ContactGroupRef {
  const ContactGroupRef({required this.id, required this.name});
  final int id;
  final String name;
}

class _ContactEditorState extends State<ContactEditor> {
  late TextEditingController _fn;
  late TextEditingController _given;
  late TextEditingController _family;
  late TextEditingController _org;
  late TextEditingController _emails;
  late TextEditingController _phones;
  late TextEditingController _note;
  late Set<int> _groupIds;

  @override
  void initState() {
    super.initState();
    final d = widget.initialDraft;
    _fn = TextEditingController(text: d.formattedName);
    _given = TextEditingController(text: d.givenName ?? '');
    _family = TextEditingController(text: d.familyName ?? '');
    _org = TextEditingController(text: d.organization ?? '');
    _emails = TextEditingController(
      text: d.emails.map((e) => e.value).join('\n'),
    );
    _phones = TextEditingController(
      text: d.phones.map((p) => p.value).join('\n'),
    );
    _note = TextEditingController(text: d.note ?? '');
    _groupIds = Set.of(d.groupIds);
  }

  @override
  void dispose() {
    _fn.dispose();
    _given.dispose();
    _family.dispose();
    _org.dispose();
    _emails.dispose();
    _phones.dispose();
    _note.dispose();
    super.dispose();
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
              controller: _fn,
              decoration: const InputDecoration(labelText: 'Display name'),
            ),
            const SizedBox(height: CourrierTokens.space3),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _given,
                    decoration: const InputDecoration(labelText: 'Given name'),
                  ),
                ),
                const SizedBox(width: CourrierTokens.space3),
                Expanded(
                  child: TextField(
                    controller: _family,
                    decoration: const InputDecoration(labelText: 'Family name'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: CourrierTokens.space3),
            TextField(
              controller: _org,
              decoration: const InputDecoration(labelText: 'Organisation'),
            ),
            const SizedBox(height: CourrierTokens.space3),
            TextField(
              controller: _emails,
              decoration: const InputDecoration(
                labelText: 'Emails (one per line)',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: CourrierTokens.space3),
            TextField(
              controller: _phones,
              decoration: const InputDecoration(
                labelText: 'Phones (one per line)',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: CourrierTokens.space3),
            TextField(
              controller: _note,
              decoration: const InputDecoration(labelText: 'Note'),
              maxLines: 3,
            ),
            if (widget.availableGroups.isNotEmpty) ...[
              const SizedBox(height: CourrierTokens.space4),
              Text('Groups', style: theme.textTheme.bodyLarge),
              for (final group in widget.availableGroups)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  value: _groupIds.contains(group.id),
                  title: Text(group.name, style: theme.textTheme.bodyMedium),
                  onChanged: (checked) => setState(() {
                    if (checked ?? false) {
                      _groupIds.add(group.id);
                    } else {
                      _groupIds.remove(group.id);
                    }
                  }),
                ),
            ],
            const SizedBox(height: CourrierTokens.space5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.onCancel != null)
                  TextButton(
                    onPressed: widget.onCancel,
                    child: const Text('Cancel'),
                  ),
                const SizedBox(width: CourrierTokens.space3),
                FilledButton(
                  onPressed: _onSavePressed,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSavePressed() async {
    final emails = _emails.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .map((value) => ContactEmail(value: value))
        .toList(growable: false);
    final phones = _phones.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .map((value) => ContactPhone(value: value))
        .toList(growable: false);

    final updated = widget.initialDraft.copyWith(
      formattedName: _fn.text.trim(),
      givenName: _given.text.isEmpty ? null : _given.text,
      familyName: _family.text.isEmpty ? null : _family.text,
      organization: _org.text.isEmpty ? null : _org.text,
      emails: emails,
      phones: phones,
      note: _note.text.isEmpty ? null : _note.text,
      groupIds: _groupIds.toList(),
    );
    await widget.onSave(updated);
  }
}
