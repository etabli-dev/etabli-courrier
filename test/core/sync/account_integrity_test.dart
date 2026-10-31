import 'package:courrier/core/auth/oauth_token_store.dart';
import 'package:courrier/core/config/secrets_store.dart';
import 'package:courrier/core/db/database.dart';
import 'package:courrier/modules/mail/autoconfig/autoconfig_models.dart';
import 'package:courrier/modules/mail/backend/demo_mail_backend.dart';
import 'package:courrier/modules/mail/backend/mail_backend.dart';
import 'package:courrier/modules/mail/backend/mail_credentials.dart';
import 'package:courrier/modules/mail/data/mail_repository.dart';
import 'package:courrier/modules/onboarding/onboarding_controller.dart';
import 'package:courrier/modules/onboarding/onboarding_state.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class FailingSecrets extends SecretsStore {
  FailingSecrets({this.failDelete = false});
  final bool failDelete;
  final values = <String, String>{};
  @override
  Future<void> write(int accountId, String purpose, String value) async {
    values['$accountId.$purpose'] = value;
    throw Exception('Injected secure-storage write failure after persistence');
  }

  @override
  Future<void> deleteAccount(int accountId) async {
    if (failDelete) throw StateError('Injected cleanup failure');
    values.removeWhere((key, _) => key.startsWith('$accountId.'));
  }
}

class ChangedMailbox extends DemoMailBackend {
  int validity = 1;
  @override
  Future<List<MailEnvelope>> fetchEnvelopes({
    required String folderName,
    int windowSize = 100,
  }) async => [
    MailEnvelope(
      uid: 1,
      uidValidity: validity,
      subject: 'Generation $validity',
      fromAddress: 'test@example.org',
      receivedAt: DateTime.utc(2026, 10, 30),
    ),
  ];
}

const config = ResolvedMailConfig(
  source: 'manual',
  incoming: MailServerConfig(
    protocol: MailServerProtocol.imap,
    host: 'imap.example.org',
    port: 993,
    socketType: MailSocketType.ssl,
    usernameTemplate: '%EMAILADDRESS%',
    authMechanism: 'password-cleartext',
  ),
  outgoing: MailServerConfig(
    protocol: MailServerProtocol.smtp,
    host: 'smtp.example.org',
    port: 587,
    socketType: MailSocketType.starttls,
    usernameTemplate: '%EMAILADDRESS%',
    authMechanism: 'password-cleartext',
  ),
);
void main() {
  for (final failCleanup in [false, true]) {
    test(
      'failed account setup preserves credential identity when cleanup fails=$failCleanup',
      () async {
        final db = CourrierDatabase.forTesting(NativeDatabase.memory());
        addTearDown(db.close);
        final secrets = FailingSecrets(failDelete: failCleanup);
        final controller = OnboardingController(
          db: db,
          secrets: secrets,
          tokenStore: OAuthTokenStore(secrets: secrets),
        );
        addTearDown(controller.dispose);
        final outcome = await controller.connectImap(
          emailAddress: 'user@example.org',
          password: 'secret',
          manualConfig: config,
          backendBuilder: (_) => DemoMailBackend(),
        );
        expect(outcome, isA<StepFailed>());
        final accounts = await db.select(db.accounts).get();
        if (failCleanup) {
          expect(accounts, hasLength(1));
          expect(accounts.single.enabled, isFalse);
          final next = await db
              .into(db.accounts)
              .insert(
                AccountsCompanion.insert(kind: 'local', displayName: 'Another'),
              );
          expect(next, isNot(accounts.single.id));
          expect(secrets.values, isNotEmpty);
        } else {
          expect(accounts, isEmpty);
          expect(secrets.values, isEmpty);
        }
      },
    );
  }
  test(
    'IMAP UIDVALIDITY change preserves old cached messages in a local archive',
    () async {
      final db = CourrierDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final account = await db
          .into(db.accounts)
          .insert(AccountsCompanion.insert(kind: 'imap', displayName: 'Mail'));
      final backend = ChangedMailbox();
      await backend.connect(
        const PasswordCredentials(username: 'u', password: 'p'),
      );
      final repo = MailRepository(db: db, backend: backend, accountId: account);
      await repo.syncFolders();
      await repo.syncEnvelopes(folderName: 'INBOX');
      final old = await db.select(db.mailMessages).getSingle();
      backend.validity = 2;
      await repo.syncEnvelopes(folderName: 'INBOX');
      final messages = await db.select(db.mailMessages).get();
      expect(
        messages.map((m) => m.subject),
        unorderedEquals(['Generation 1', 'Generation 2']),
      );
      final inbox = await repo.folderByName('INBOX');
      expect(inbox.uidValidity, 2);
      expect(inbox.id, isNot(old.folderId));
      final archive = await (db.select(
        db.mailFolders,
      )..where((t) => t.id.equals(old.folderId))).getSingle();
      expect(
        (await (db.select(
          db.accounts,
        )..where((t) => t.id.equals(archive.accountId))).getSingle()).kind,
        'local',
      );
      await expectLater(
        repo.loadBody(folderName: 'INBOX', messageId: old.id),
        throwsStateError,
      );
    },
  );
}
