import 'package:flutter/material.dart';

import '../../shell/module_placeholder.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholder(
      title: 'feeds',
      synopsis:
          'Nextcloud News API + bundled standalone parser fallback (M10).'
          ' Offline reading, shared CustomIntervalPicker for refresh.',
    );
  }
}
