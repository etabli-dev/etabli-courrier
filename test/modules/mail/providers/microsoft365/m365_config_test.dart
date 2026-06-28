import 'package:courrier/modules/mail/providers/microsoft365/m365_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('M365Config — PREFLIGHT locked decisions', () {
    test('Default IMAP host + port + SMTP host + port match PREFLIGHT', () {
      const config = M365Config(
        clientId: '00000000-0000-0000-0000-000000000000',
      );
      expect(config.imapHost, 'outlook.office365.com');
      expect(config.imapPort, 993);
      expect(config.smtpHost, 'smtp.office365.com');
      expect(config.smtpPort, 587);
    });

    test('Default redirect URI matches PREFLIGHT locked scheme', () {
      const config = M365Config(clientId: 'x');
      expect(config.redirectUri, 'dev.etabli.courrier://oauth');
    });

    test('Default authority is login.microsoftonline.com/common', () {
      const config = M365Config(clientId: 'x');
      expect(config.authority, 'https://login.microsoftonline.com/common');
    });

    test(
      'Scopes contain offline_access + IMAP.AccessAsUser.All + SMTP.Send',
      () {
        const config = M365Config(clientId: 'x');
        expect(
          config.scopes,
          containsAll([
            'offline_access',
            'https://outlook.office.com/IMAP.AccessAsUser.All',
            'https://outlook.office.com/SMTP.Send',
          ]),
        );
      },
    );

    test('toClientConfig emits issuer + authorization + token endpoints', () {
      const config = M365Config(clientId: 'cli');
      final client = config.toClientConfig();
      expect(client.clientId, 'cli');
      expect(client.redirectUri, 'dev.etabli.courrier://oauth');
      expect(client.issuer, 'https://login.microsoftonline.com/common/v2.0');
      expect(
        client.endpoints?.authorizationEndpoint,
        'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
      );
      expect(
        client.endpoints?.tokenEndpoint,
        'https://login.microsoftonline.com/common/oauth2/v2.0/token',
      );
    });
  });
}
