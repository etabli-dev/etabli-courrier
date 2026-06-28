import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// F-Droid modularity invariant (BUILD_PROMPT M8 + LICENSING.md). Every
// Microsoft-specific identifier MUST live under
// `lib/modules/mail/providers/microsoft365/`. This is what lets the core
// stay F-Droid-clean — the M365 module triggers the `NonFreeNet` anti-feature
// and the provider isolation keeps the rest of the binary from inheriting it.
//
// The license-gate.yml workflow runs an advisory grep with the same shape.
// This test is the build-time enforcer.

const _identifiers = [
  'login.microsoftonline.com',
  'outlook.office365.com',
  'outlook.office.com',
  'smtp.office365.com',
];

void main() {
  test(
    'M365 identifiers do NOT leak outside lib/modules/mail/providers/microsoft365/',
    () {
      final libDir = Directory('lib');
      final offenders = <String>[];
      for (final entity in libDir.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) {
          continue;
        }
        if (entity.path.contains('modules/mail/providers/microsoft365')) {
          continue;
        }
        final content = entity.readAsStringSync().toLowerCase();
        for (final id in _identifiers) {
          if (content.contains(id.toLowerCase())) {
            offenders.add('${entity.path}: contains "$id"');
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'M365 identifiers leaked outside the provider module — fix '
            'before audit dim 8 / F-Droid check fail.',
      );
    },
  );
}
