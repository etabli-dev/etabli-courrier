import 'package:meta/meta.dart';

// Funding flavor — set at build time via --dart-define=FUNDING_FLAVOR=...
//   * `bmc`       — Buy Me a Coffee (App Store / Google Play / GitHub Releases)
//   * `liberapay` — Liberapay (F-Droid)
//
// Defaults to BMC to match the most common build. The F-Droid metadata at
// M15 sets `liberapay` so its build flavor surfaces the right link.

const String _fundingFlavor = String.fromEnvironment(
  'FUNDING_FLAVOR',
  defaultValue: 'bmc',
);

@immutable
class AboutInfo {
  const AboutInfo({
    required this.versionLabel,
    required this.fundingLabel,
    required this.fundingUrl,
  });

  static AboutInfo current({String versionLabel = 'v0.1.0'}) {
    if (_fundingFlavor == 'liberapay') {
      return AboutInfo(
        versionLabel: versionLabel,
        fundingLabel: 'Liberapay',
        fundingUrl: 'https://liberapay.com/etabli',
      );
    }
    return AboutInfo(
      versionLabel: versionLabel,
      fundingLabel: 'Buy Me a Coffee',
      fundingUrl: 'https://www.buymeacoffee.com/etabli',
    );
  }

  final String versionLabel;
  final String fundingLabel;
  final String fundingUrl;

  static String get rawFundingFlavor => _fundingFlavor;
}
