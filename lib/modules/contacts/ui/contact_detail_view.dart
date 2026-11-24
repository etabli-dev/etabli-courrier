import 'package:flutter/material.dart';

import '../../../core/db/database.dart';
import '../../../core/ical/ical_reader.dart';
import '../../../core/ical/vcard.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/l10n.dart';

class ContactDetailView extends StatelessWidget {
  const ContactDetailView({required this.contact, super.key});

  final ContactCard contact;

  static const IcalReader _reader = IcalReader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    VCard? vcard;
    try {
      vcard = VCard.from(_reader.parse(contact.rawVcard));
    } on FormatException {
      vcard = null;
    }

    final emails = vcard?.emails.toList(growable: false) ?? const <String>[];
    final phones = vcard?.phones.toList(growable: false) ?? const <String>[];
    final addresses =
        vcard?.addresses.toList(growable: false) ?? const <String>[];

    return ListView(
      padding: const EdgeInsets.all(CourrierTokens.space5),
      children: [
        Text(
          contact.formattedName ?? l10n.contactsNoName,
          style: theme.textTheme.titleLarge,
        ),
        if (contact.organization != null) ...[
          const SizedBox(height: CourrierTokens.space1),
          Text(contact.organization!, style: theme.textTheme.bodyMedium),
        ],
        const SizedBox(height: CourrierTokens.space5),
        _Section(label: l10n.contactsEmail, items: emails),
        _Section(label: l10n.contactsPhone, items: phones),
        _Section(label: l10n.contactsAddress, items: addresses),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.label, required this.items});

  final String label;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: CourrierTokens.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          const SizedBox(height: CourrierTokens.space1),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: CourrierTokens.space1,
              ),
              child: Text(item, style: theme.textTheme.bodyMedium),
            ),
        ],
      ),
    );
  }
}
