import 'package:courrier/core/settings/about_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Defaults to BMC when FUNDING_FLAVOR is unset', () {
    // Without --dart-define=FUNDING_FLAVOR=... the const String.fromEnvironment
    // resolves to the default ('bmc').
    expect(AboutInfo.rawFundingFlavor, 'bmc');
    final about = AboutInfo.current();
    expect(about.fundingLabel, 'Buy Me a Coffee');
    expect(about.fundingUrl, contains('buymeacoffee'));
  });

  test('versionLabel propagates from the caller', () {
    final about = AboutInfo.current(versionLabel: 'v0.2.0+beta');
    expect(about.versionLabel, 'v0.2.0+beta');
  });
}
