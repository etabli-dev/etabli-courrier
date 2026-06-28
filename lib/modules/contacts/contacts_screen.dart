import 'package:flutter/material.dart';

import '../../core/db/database.dart';
import 'data/contact_repository.dart';
import 'ui/contact_detail_view.dart';
import 'ui/contacts_list_view.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({required this.repository, super.key});

  final ContactRepository repository;

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  ContactCard? _selected;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ContactCard>>(
      stream: widget.repository.watchContacts(),
      builder: (context, snapshot) {
        final contacts = snapshot.data ?? const <ContactCard>[];
        final selected = _selected;
        if (selected != null) {
          return Stack(
            children: [
              ContactDetailView(contact: selected),
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => setState(() => _selected = null),
                ),
              ),
            ],
          );
        }
        return ContactsListView(
          contacts: contacts,
          onContactTap: (c) => setState(() => _selected = c),
        );
      },
    );
  }
}
