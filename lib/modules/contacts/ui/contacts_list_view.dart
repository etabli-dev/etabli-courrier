import 'package:flutter/material.dart';

import '../../../core/db/database.dart';
import '../../../core/theme/tokens.dart';

class ContactsListView extends StatelessWidget {
  const ContactsListView({
    required this.contacts,
    this.onContactTap,
    super.key,
  });

  final List<ContactCard> contacts;
  final ValueChanged<ContactCard>? onContactTap;

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return const _Empty();
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: CourrierTokens.space5,
        vertical: CourrierTokens.space3,
      ),
      itemCount: contacts.length,
      separatorBuilder: (_, _) => const Divider(height: CourrierTokens.space4),
      itemBuilder: (context, i) {
        final c = contacts[i];
        return _ContactTile(
          contact: c,
          onTap: onContactTap == null ? null : () => onContactTap!(c),
        );
      },
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.contact, this.onTap});

  final ContactCard contact;
  final VoidCallback? onTap;

  String get _initial {
    final source =
        contact.formattedName ?? contact.givenName ?? contact.familyName ?? '·';
    return source.trimLeft().isEmpty ? '·' : source.trimLeft()[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: CourrierTokens.space2),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerTheme.color!),
              ),
              child: Text(_initial, style: theme.textTheme.bodyLarge),
            ),
            const SizedBox(width: CourrierTokens.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.formattedName ??
                        '${contact.givenName ?? ''} ${contact.familyName ?? ''}'
                            .trim(),
                    style: theme.textTheme.titleMedium,
                  ),
                  if (contact.organization != null)
                    Text(
                      contact.organization!,
                      style: theme.textTheme.bodySmall,
                    ),
                  if (contact.primaryEmail != null)
                    Text(
                      contact.primaryEmail!,
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(CourrierTokens.space6),
        child: Text(
          'No contacts yet.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
