import 'package:flutter/material.dart';

import '../core/theme/tokens.dart';

class ModulePlaceholder extends StatelessWidget {
  const ModulePlaceholder({
    required this.title,
    required this.synopsis,
    super.key,
  });

  final String title;
  final String synopsis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(CourrierTokens.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: CourrierTokens.space2),
          Container(
            width: CourrierTokens.space7,
            height: CourrierTokens.borderWidth,
            color: CourrierTokens.accent,
          ),
          const SizedBox(height: CourrierTokens.space5),
          Text(synopsis, style: theme.textTheme.bodyMedium),
          const SizedBox(height: CourrierTokens.space5),
          Text(
            'Empty by design at M0. Module wired in during its milestone.',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
