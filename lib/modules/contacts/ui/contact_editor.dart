import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../l10n/l10n.dart';
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
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(CourrierTokens.space5),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _fn,
              decoration: InputDecoration(labelText: l10n.contactsDisplayName),
            ),
            const SizedBox(height: CourrierTokens.space3),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _given,
                    decoration: InputDecoration(
                      labelText: l10n.contactsGivenName,
                    ),
                  ),
                ),
                const SizedBox(width: CourrierTokens.space3),
                Expanded(
                  child: TextField(
                    controller: _family,
                    decoration: InputDecoration(
                      labelText: l10n.contactsFamilyName,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: CourrierTokens.space3),
            TextField(
              controller: _org,
              decoration: InputDecoration(labelText: l10n.contactsOrganisation),
            ),
            const SizedBox(height: CourrierTokens.space3),
            TextField(
              controller: _emails,
              decoration: InputDecoration(labelText: l10n.contactsEmails),
              maxLines: 3,
            ),
            const SizedBox(height: CourrierTokens.space3),
            TextField(
              controller: _phones,
              decoration: InputDecoration(labelText: l10n.contactsPhones),
              maxLines: 3,
            ),
            const SizedBox(height: CourrierTokens.space3),
            TextField(
              controller: _note,
              decoration: InputDecoration(labelText: l10n.contactsNote),
              maxLines: 3,
            ),
            if (widget.availableGroups.isNotEmpty) ...[
              const SizedBox(height: CourrierTokens.space4),
              Text(l10n.contactsGroups, style: theme.textTheme.bodyLarge),
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
                    child: Text(l10n.commonCancel),
                  ),
                const SizedBox(width: CourrierTokens.space3),
                FilledButton(
                  onPressed: _onSavePressed,
                  child: Text(l10n.commonSave),
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
