import 'package:flutter/material.dart';

import '../../shell/module_placeholder.dart';

class MailScreen extends StatelessWidget {
  const MailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholder(
      title: 'mail',
      synopsis:
          'IMAP + SMTP with XOAUTH2 (M6–M8). Offline store, threading,'
          ' soft-delete trash, local-first search.',
    );
  }
}
