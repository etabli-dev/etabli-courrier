import '../../../../core/auth/oauth_provider.dart';
import '../../../../core/auth/oauth_token_store.dart';
import '../../../../core/net/net_error.dart';
import '../../backend/imap_mail_backend.dart';
import '../../backend/mail_backend.dart';
import '../../backend/mail_credentials.dart';
import 'm365_config.dart';
import 'tenant_state.dart';

// Microsoft 365 mail backend. Wraps the M6 ImapMailBackend with an OAuth
// token-refresh-on-Unauthorized loop + a TenantState surface so the UI can
// render an actionable card on each well-known friction case.
//
// One layer down it's just the M6+M7 IMAP+SMTP path — that's the design
// payoff for keeping MailBackend auth-agnostic (M6) + sendMessage on the
// same interface (M7). No protocol fork.

class M365Backend implements MailBackend {
  M365Backend({
    required this.config,
    required this.oauthProvider,
    required this.tokenStore,
    required this.accountId,
    required this.userEmail,
    ImapMailBackend? imapBackend,
    this.classifier = const TenantStateClassifier(),
  }) : _imap =
           imapBackend ??
           ImapMailBackend(
             host: config.imapHost,
             port: config.imapPort,
             smtpHost: config.smtpHost,
             smtpPort: config.smtpPort,
           );

  final M365Config config;
  final OAuthProvider oauthProvider;
  final OAuthTokenStore tokenStore;
  final int accountId;
  final String userEmail;
  final TenantStateClassifier classifier;
  final ImapMailBackend _imap;

  AuthBundle? _bundle;
  TenantState _tenantState = const TenantConnected();

  TenantState get tenantState => _tenantState;

  /// First-run interactive sign-in. Opens the system browser via the OAuth
  /// provider, persists refresh token, connects IMAP + caches the bundle.
  Future<TenantState> signInAndConnect() async {
    try {
      final bundle = await oauthProvider.signIn(config.toClientConfig());
      _bundle = bundle;
      await tokenStore.persist(accountId: accountId, bundle: bundle);
      await _connectImap(bundle);
      _tenantState = const TenantConnected();
      return _tenantState;
    } on OAuthError catch (e) {
      _tenantState = classifier.classifyOAuthError(e);
      return _tenantState;
    } on NetError catch (e) {
      _tenantState = classifier.classifyMailError(e);
      return _tenantState;
    }
  }

  /// Silent reconnect — uses the persisted refresh token if the access token
  /// is about to expire. Used on cold-start.
  Future<TenantState> silentReconnect() async {
    final refreshToken = await tokenStore.readRefreshToken(accountId);
    if (refreshToken == null) {
      _tenantState = const TenantAuthFailedGeneric(
        detail: 'No refresh token stored — sign in again.',
      );
      return _tenantState;
    }
    try {
      final bundle = await oauthProvider.refresh(
        config: config.toClientConfig(),
        refreshToken: refreshToken,
      );
      _bundle = bundle;
      await tokenStore.persist(accountId: accountId, bundle: bundle);
      await _connectImap(bundle);
      _tenantState = const TenantConnected();
      return _tenantState;
    } on OAuthError catch (e) {
      _tenantState = classifier.classifyOAuthError(e);
      return _tenantState;
    } on NetError catch (e) {
      _tenantState = classifier.classifyMailError(e);
      return _tenantState;
    }
  }

  Future<void> _connectImap(AuthBundle bundle) async {
    await _imap.connect(
      XoauthBearerCredentials(
        username: userEmail,
        accessToken: bundle.accessToken,
        tokenExpiresAt: bundle.expiresAt,
      ),
    );
  }

  /// Internal helper — runs [body] and, if it surfaces UnauthorizedError,
  /// performs one silent refresh + retry. Subsequent failures classify the
  /// tenant state and re-throw.
  Future<T> _withRefreshRetry<T>(Future<T> Function() body) async {
    try {
      final current = _bundle;
      if (current != null && current.willExpireSoon()) {
        await silentReconnect();
      }
      return await body();
    } on UnauthorizedError {
      final next = await silentReconnect();
      if (next is! TenantConnected) {
        throw const UnauthorizedError();
      }
      return body();
    }
  }

  // ---- MailBackend delegations ------------------------------------------

  @override
  Future<void> connect(MailCredentials credentials) async {
    if (credentials is! XoauthBearerCredentials) {
      throw ArgumentError('M365Backend requires XoauthBearerCredentials');
    }
    _bundle = AuthBundle(
      accessToken: credentials.accessToken,
      refreshToken: null,
      expiresAt:
          credentials.tokenExpiresAt ??
          DateTime.now().add(const Duration(hours: 1)),
    );
    await _connectImap(_bundle!);
  }

  @override
  Future<void> disconnect() => _imap.disconnect();

  @override
  Future<List<MailFolderHandle>> listFolders() =>
      _withRefreshRetry(_imap.listFolders);

  @override
  Future<List<MailEnvelope>> fetchEnvelopes({
    required String folderName,
    int windowSize = 100,
  }) => _withRefreshRetry(
    () => _imap.fetchEnvelopes(folderName: folderName, windowSize: windowSize),
  );

  @override
  Future<MailBodyPayload> fetchBody({
    required String folderName,
    required int uid,
  }) => _withRefreshRetry(
    () => _imap.fetchBody(folderName: folderName, uid: uid),
  );

  @override
  Future<void> applyFlags({
    required String folderName,
    required List<FlagUpdate> updates,
  }) => _withRefreshRetry(
    () => _imap.applyFlags(folderName: folderName, updates: updates),
  );

  @override
  Future<void> moveMessages({
    required String sourceFolder,
    required String destinationFolder,
    required List<int> uids,
  }) => _withRefreshRetry(
    () => _imap.moveMessages(
      sourceFolder: sourceFolder,
      destinationFolder: destinationFolder,
      uids: uids,
    ),
  );

  @override
  Future<void> expungeTrash({required String trashFolderName}) =>
      _withRefreshRetry(
        () => _imap.expungeTrash(trashFolderName: trashFolderName),
      );

  @override
  Future<int> appendMessage({
    required String folderName,
    required String rawMimeBytes,
  }) => _withRefreshRetry(
    () =>
        _imap.appendMessage(folderName: folderName, rawMimeBytes: rawMimeBytes),
  );

  @override
  Future<void> sendMessage({
    required String rawMimeBytes,
    required String fromAddress,
    required List<String> recipients,
  }) => _withRefreshRetry(
    () => _imap.sendMessage(
      rawMimeBytes: rawMimeBytes,
      fromAddress: fromAddress,
      recipients: recipients,
    ),
  );

  @override
  Future<void> startIdle({
    required String folderName,
    required void Function(int uid) onEnvelope,
  }) => _imap.startIdle(folderName: folderName, onEnvelope: onEnvelope);

  @override
  Future<void> stopIdle() => _imap.stopIdle();
}
