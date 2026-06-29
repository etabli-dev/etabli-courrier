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

// User-facing documentation index. Rendered by GitHub as the project's
// vignette table-of-contents. Surfaced from Settings → About so end users
// have a reachable entry point — the docs/ folder otherwise has no path
// from the app or the store listing.
const String _docsIndexUrl =
    'https://github.com/etabli-dev/etabli-courrier/blob/main/docs/vignettes/index.md';

@immutable
class AboutInfo {
  const AboutInfo({
    required this.versionLabel,
    required this.fundingLabel,
    required this.fundingUrl,
    required this.docsUrl,
  });

  static AboutInfo current({String versionLabel = 'v0.1.0'}) {
    if (_fundingFlavor == 'liberapay') {
      return AboutInfo(
        versionLabel: versionLabel,
        fundingLabel: 'Liberapay',
        fundingUrl: 'https://liberapay.com/etabli',
        docsUrl: _docsIndexUrl,
      );
    }
    return AboutInfo(
      versionLabel: versionLabel,
      fundingLabel: 'Buy Me a Coffee',
      fundingUrl: 'https://www.buymeacoffee.com/etabli',
      docsUrl: _docsIndexUrl,
    );
  }

  final String versionLabel;
  final String fundingLabel;
  final String fundingUrl;
  final String docsUrl;

  static String get rawFundingFlavor => _fundingFlavor;
}
