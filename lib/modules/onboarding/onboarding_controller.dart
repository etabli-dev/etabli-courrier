import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/auth/oauth_token_store.dart';
import '../../core/config/secrets_store.dart';
import '../../core/db/database.dart';
import '../../core/net/bounded_http.dart';
import '../../core/net/dav/dav_client.dart';
import '../../core/net/dav/discovery.dart';
import '../../core/net/net_error.dart';
import '../mail/autoconfig/autoconfig_models.dart';
import '../mail/autoconfig/autoconfig_resolver.dart';
import '../mail/backend/imap_mail_backend.dart';
import '../mail/backend/mail_backend.dart';
import '../mail/backend/mail_credentials.dart';
import '../mail/providers/microsoft365/m365_backend.dart';
import '../mail/providers/microsoft365/m365_config.dart';
import '../mail/providers/microsoft365/tenant_state.dart';
import 'onboarding_state.dart';

// Drives the unified onboarding flow. Each step is idempotent + skippable.
// The controller is pure-Dart so widget tests can drive it without a UI.

class OnboardingController {
  OnboardingController({
    required this.db,
    required this.secrets,
    required this.tokenStore,
  });

  final CourrierDatabase db;
  final SecretsStore secrets;
  final OAuthTokenStore tokenStore;

  final StreamController<OnboardingState> _events =
      StreamController<OnboardingState>.broadcast();

  OnboardingState _state = const OnboardingState();
  OnboardingState get state => _state;
  Stream<OnboardingState> get events => _events.stream;

  void _emit(OnboardingState next) {
    _state = next;
    if (!_events.isClosed) _events.add(next);
  }

  Future<void> dispose() => _events.close();

  // ---- Stage 1: Nextcloud ------------------------------------------------

  /// Connect to a Nextcloud server, run DAV discovery, persist one account
  /// row with calendar + addressbook + notes + feeds collections.
  Future<StepOutcome> connectNextcloud({
    required String baseUrl,
    required String username,
    required String appPassword,
    DavClient Function(DavCredentials)? clientBuilder,
  }) async {
    _emit(
      _state.copyWith(
        stage: OnboardingStage.nextcloud,
        nextcloud: const StepInProgress(),
      ),
    );
    try {
      serverBase(baseUrl);
      if (username.trim().isEmpty || appPassword.isEmpty) {
        throw const FormatException('Username and app password are required.');
      }
      final credentials = DavCredentials(
        username: username,
        password: appPassword,
      );
      final client = clientBuilder == null
          ? DavClient(credentials: credentials)
          : clientBuilder(credentials);
      try {
        final discovery = DavDiscovery(
          client: client,
          baseUrl: serverBase(baseUrl),
        );
        final result = await discovery.discover();

        if (result.principalHref == null) {
          throw const FormatException(
            'No authenticated DAV principal was found.',
          );
        }
        final base = serverBase(baseUrl);
        final specs = <({String kind, String name, String? href})>[];
        for (final calendar in result.calendarCollections) {
          final href = sameOrigin(base, calendar.href).toString();
          final components = calendar.supportedCalendarComponentSet?.split(',');
          if (components == null || components.contains('VEVENT')) {
            specs.add((
              kind: 'calendar',
              name: calendar.displayName ?? 'Calendar',
              href: href,
            ));
          }
          if (components == null || components.contains('VTODO')) {
            specs.add((
              kind: 'tasks',
              name: calendar.displayName ?? 'Tasks',
              href: href,
            ));
          }
        }
        for (final book in result.addressbookCollections) {
          specs.add((
            kind: 'contacts',
            name: book.displayName ?? 'Address book',
            href: sameOrigin(base, book.href).toString(),
          ));
        }
        specs.addAll([
          (kind: 'notes', name: 'Notes', href: null),
          (kind: 'feeds', name: 'News', href: null),
        ]);
        final collectionIds = <int>[];
        final accountId = await _storeAccount(
          kind: 'nextcloud',
          displayName: 'Nextcloud ($username)',
          baseUrl: base.toString(),
          username: username,
          values: {'app_password': appPassword},
          collections: (id) async {
            for (final spec in specs) {
              collectionIds.add(
                await db
                    .into(db.collections)
                    .insert(
                      CollectionsCompanion.insert(
                        accountId: id,
                        kind: spec.kind,
                        displayName: spec.name,
                        remoteHref: Value(spec.href),
                      ),
                    ),
              );
            }
          },
        );

        final outcome = StepSucceeded(
          accountId: accountId,
          collectionIds: collectionIds,
          detail:
              'Discovered ${result.calendarCollections.length} calendar(s) '
              '+ ${result.addressbookCollections.length} address book(s).',
        );
        _emit(_state.copyWith(nextcloud: outcome));
        return outcome;
      } finally {
        await client.close();
      }
    } on NetError catch (e) {
      final outcome = StepFailed(
        message: 'Nextcloud connection failed (${e.kind}).',
        detail: e.message,
      );
      _emit(_state.copyWith(nextcloud: outcome));
      return outcome;
    } on FormatException catch (e) {
      final outcome = StepFailed(
        message: 'Bad URL — please paste your Nextcloud base URL.',
        detail: e.message,
      );
      _emit(_state.copyWith(nextcloud: outcome));
      return outcome;
    } on Exception {
      const outcome = StepFailed(
        message: 'Could not save the account. Check secure storage and retry.',
      );
      _emit(_state.copyWith(nextcloud: outcome));
      return outcome;
    }
  }

  void skipNextcloud() {
    _emit(
      _state.copyWith(
        nextcloud: const StepSkipped(),
        stage: OnboardingStage.imap,
      ),
    );
  }

  // ---- Stage 2: IMAP autoconfig ------------------------------------------

  /// Resolve a mail server config via M7 autoconfig + seed an IMAP account.
  Future<StepOutcome> connectImap({
    required String emailAddress,
    required String password,
    AutoconfigResolver? resolver,
    ResolvedMailConfig? manualConfig,
    MailBackend Function(ResolvedMailConfig)? backendBuilder,
  }) async {
    _emit(
      _state.copyWith(
        stage: OnboardingStage.imap,
        imap: const StepInProgress(),
      ),
    );
    try {
      final r = resolver ?? AutoconfigResolver();
      final config = manualConfig ?? await r.resolve(emailAddress);
      if (config == null) {
        final outcome = StepFailed(
          message: 'No autoconfig found for ${emailAddress.split('@').last}.',
          detail: 'Add the server manually from Settings → Accounts.',
        );
        _emit(_state.copyWith(imap: outcome));
        return outcome;
      }
      if (emailAddress.trim().isEmpty || password.isEmpty) {
        throw const FormatException('Email and password are required.');
      }
      if (config.incoming.socketType == MailSocketType.plain ||
          config.outgoing.socketType == MailSocketType.plain) {
        throw const FormatException(
          'Unencrypted mail connections are not supported.',
        );
      }
      for (final server in [config.incoming, config.outgoing]) {
        if (server.host.isEmpty ||
            server.host.contains(RegExp(r'[\s/@]')) ||
            server.port < 1 ||
            server.port > 65535) {
          throw const FormatException('Invalid mail server or port.');
        }
      }
      final username = config.incoming.resolveUsername(emailAddress);
      if (username != config.outgoing.resolveUsername(emailAddress)) {
        throw const FormatException(
          'Separate SMTP usernames are not supported yet.',
        );
      }
      final backend =
          backendBuilder?.call(config) ??
          ImapMailBackend(
            host: config.incoming.host,
            port: config.incoming.port,
            isSecure: config.incoming.socketType == MailSocketType.ssl,
          );
      try {
        await backend
            .connect(
              PasswordCredentials(username: username, password: password),
            )
            .timeout(const Duration(seconds: 30));
        await backend.listFolders().timeout(const Duration(seconds: 30));
      } finally {
        await backend.disconnect();
      }
      final accountId = await _storeAccount(
        kind: 'imap',
        displayName: emailAddress,
        baseUrl: config.incoming.host,
        username: username,
        values: {
          'password': password,
          'mail_config': jsonEncode({
            'host': config.incoming.host,
            'port': config.incoming.port,
            'tls': config.incoming.socketType.name,
            'smtpHost': config.outgoing.host,
            'smtpPort': config.outgoing.port,
            'smtpTls': config.outgoing.socketType.name,
          }),
        },
      );
      final outcome = StepSucceeded(
        accountId: accountId,
        detail:
            'IMAP via ${config.incoming.host}:${config.incoming.port} '
            '(${config.source}).',
      );
      _emit(_state.copyWith(imap: outcome));
      return outcome;
    } on Exception catch (e) {
      final outcome = StepFailed(
        message:
            'Mail connection failed. Check the server settings and app password.',
        detail: e is FormatException ? e.message.toString() : null,
      );
      _emit(_state.copyWith(imap: outcome));
      return outcome;
    }
  }

  void skipImap() {
    _emit(
      _state.copyWith(
        imap: const StepSkipped(),
        stage: OnboardingStage.microsoft365,
      ),
    );
  }

  // ---- Stage 3: Microsoft 365 OAuth (optional) ---------------------------

  /// Run the M365 sign-in. The backend handles tenant friction routing; the
  /// controller persists an account row only on success.
  Future<StepOutcome> connectMicrosoft365({
    required M365Backend backend,
    required String userEmail,
  }) async {
    _emit(
      _state.copyWith(
        stage: OnboardingStage.microsoft365,
        microsoft365: const StepInProgress(),
      ),
    );
    var reserved = false;
    try {
      if (backend.accountId <= 0) {
        throw const FormatException('Invalid OAuth account identity.');
      }
      await db
          .into(db.accounts)
          .insert(
            AccountsCompanion.insert(
              kind: 'm365',
              id: Value(backend.accountId),
              displayName: userEmail,
              username: Value(userEmail),
              enabled: const Value(false),
            ),
          );
      reserved = true;
      final tenantState = await backend.signInAndConnect();
      if (tenantState is! TenantConnected) {
        throw StateError('Sign-in did not connect.');
      }
      await (db.update(db.accounts)
            ..where((t) => t.id.equals(backend.accountId)))
          .write(const AccountsCompanion(enabled: Value(true)));
      final outcome = StepSucceeded(
        accountId: backend.accountId,
        detail: 'Connected via OAuth + IMAP XOAUTH2.',
      );
      _emit(_state.copyWith(microsoft365: outcome));
      return outcome;
    } on Object {
      if (reserved) {
        try {
          await tokenStore.wipe(backend.accountId);
          await (db.delete(
            db.accounts,
          )..where((t) => t.id.equals(backend.accountId))).go();
        } on Object {
          /* Retain the disabled identity if secure cleanup fails. */
        }
      }
      const outcome = StepFailed(
        message: 'Microsoft 365 sign-in failed. Cached accounts are unchanged.',
      );
      _emit(_state.copyWith(microsoft365: outcome));
      return outcome;
    } finally {
      if (reserved) await backend.disconnect();
    }
  }

  void skipMicrosoft365() {
    _emit(
      _state.copyWith(
        microsoft365: const StepSkipped(),
        stage: OnboardingStage.finished,
      ),
    );
  }

  void finish() {
    _emit(_state.copyWith(stage: OnboardingStage.finished));
  }

  Future<int> _storeAccount({
    required String kind,
    required String displayName,
    required String baseUrl,
    required String username,
    required Map<String, String> values,
    Future<void> Function(int)? collections,
  }) async {
    final existing =
        await (db.select(db.accounts)..where(
              (t) =>
                  t.kind.equals(kind) &
                  t.baseUrl.equals(baseUrl) &
                  t.username.equals(username),
            ))
            .get();
    if (existing.isNotEmpty) {
      final id = existing.single.id;
      await secrets.write(id, 'connection', jsonEncode(values));
      await (db.update(db.accounts)..where((t) => t.id.equals(id))).write(
        const AccountsCompanion(enabled: Value(true)),
      );
      return id;
    }
    // Reserve the ID before touching external secure storage. If cleanup fails,
    // keep a disabled row so another account cannot inherit its secret slots.
    final id = await db
        .into(db.accounts)
        .insert(
          AccountsCompanion.insert(
            kind: kind,
            displayName: displayName,
            baseUrl: Value(baseUrl),
            username: Value(username),
            enabled: const Value(false),
          ),
        );
    try {
      await secrets.write(id, 'connection', jsonEncode(values));
      await db.transaction(() async {
        if (collections != null) await collections(id);
        await (db.update(db.accounts)..where((t) => t.id.equals(id))).write(
          const AccountsCompanion(enabled: Value(true)),
        );
      });
      return id;
    } on Object {
      try {
        await secrets.deleteAccount(id);
        await (db.delete(db.accounts)..where((t) => t.id.equals(id))).go();
      } on Object {
        /* Retain the disabled account identity for recovery. */
      }
      rethrow;
    }
  }

  /// Convenience for tests + the production wiring — surfaces the canonical
  /// `M365Config` from PREFLIGHT-locked values so the controller doesn't
  /// inline endpoint strings (kept in the M365 provider module).
  static M365Config defaultM365Config(String clientId) =>
      M365Config(clientId: clientId);
}
