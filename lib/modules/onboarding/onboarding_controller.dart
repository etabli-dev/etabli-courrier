import 'dart:async';

import 'package:drift/drift.dart';

import '../../core/auth/oauth_token_store.dart';
import '../../core/config/secrets_store.dart';
import '../../core/db/database.dart';
import '../../core/net/dav/dav_client.dart';
import '../../core/net/dav/discovery.dart';
import '../../core/net/net_error.dart';
import '../mail/autoconfig/autoconfig_resolver.dart';
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
    _events.add(next);
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
          baseUrl: Uri.parse(baseUrl),
        );
        final result = await discovery.discover();

        final accountId = await db
            .into(db.accounts)
            .insert(
              AccountsCompanion.insert(
                kind: 'nextcloud',
                displayName: 'Nextcloud ($username)',
                baseUrl: Value(baseUrl),
                username: Value(username),
              ),
            );
        await secrets.write(accountId, 'app_password', appPassword);

        final collectionIds = <int>[];
        for (final calendar in result.calendarCollections) {
          collectionIds.add(
            await db
                .into(db.collections)
                .insert(
                  CollectionsCompanion.insert(
                    accountId: accountId,
                    kind: 'calendar',
                    displayName: calendar.displayName ?? 'Calendar',
                    remoteHref: Value(calendar.href),
                    ctag: Value(calendar.ctag),
                    syncToken: Value(calendar.syncToken),
                  ),
                ),
          );
        }
        for (final book in result.addressbookCollections) {
          collectionIds.add(
            await db
                .into(db.collections)
                .insert(
                  CollectionsCompanion.insert(
                    accountId: accountId,
                    kind: 'contacts',
                    displayName: book.displayName ?? 'Address book',
                    remoteHref: Value(book.href),
                  ),
                ),
          );
        }
        // Notes + News are app-level — seed one collection each so the
        // module sync backends pick them up on next pull. M11 also wires
        // them automatically; we make them visible to the user here.
        collectionIds.add(
          await db
              .into(db.collections)
              .insert(
                CollectionsCompanion.insert(
                  accountId: accountId,
                  kind: 'notes',
                  displayName: 'Notes',
                ),
              ),
        );
        collectionIds.add(
          await db
              .into(db.collections)
              .insert(
                CollectionsCompanion.insert(
                  accountId: accountId,
                  kind: 'feeds',
                  displayName: 'News',
                ),
              ),
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
  }) async {
    _emit(
      _state.copyWith(
        stage: OnboardingStage.imap,
        imap: const StepInProgress(),
      ),
    );
    try {
      final r = resolver ?? AutoconfigResolver();
      final config = await r.resolve(emailAddress);
      if (config == null) {
        final outcome = StepFailed(
          message: 'No autoconfig found for ${emailAddress.split('@').last}.',
          detail: 'Add the server manually from Settings → Accounts.',
        );
        _emit(_state.copyWith(imap: outcome));
        return outcome;
      }
      final accountId = await db
          .into(db.accounts)
          .insert(
            AccountsCompanion.insert(
              kind: 'imap',
              displayName: emailAddress,
              baseUrl: Value(config.incoming.host),
              username: Value(config.incoming.resolveUsername(emailAddress)),
            ),
          );
      await secrets.write(accountId, 'password', password);
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
        message: 'IMAP autoconfig failed.',
        detail: e.toString(),
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
    final tenantState = await backend.signInAndConnect();
    if (tenantState is TenantConnected) {
      final accountId = await db
          .into(db.accounts)
          .insert(
            AccountsCompanion.insert(
              kind: 'm365',
              displayName: userEmail,
              username: Value(userEmail),
            ),
          );
      final outcome = StepSucceeded(
        accountId: accountId,
        detail: 'Connected via OAuth + IMAP XOAUTH2.',
      );
      _emit(_state.copyWith(microsoft365: outcome));
      return outcome;
    }
    final outcome = StepFailed(
      message: 'Microsoft 365 sign-in failed.',
      detail: tenantState.runtimeType.toString(),
    );
    _emit(_state.copyWith(microsoft365: outcome));
    return outcome;
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

  /// Convenience for tests + the production wiring — surfaces the canonical
  /// `M365Config` from PREFLIGHT-locked values so the controller doesn't
  /// inline endpoint strings (kept in the M365 provider module).
  static M365Config defaultM365Config(String clientId) =>
      M365Config(clientId: clientId);
}
