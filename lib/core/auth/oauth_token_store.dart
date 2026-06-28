import '../config/secrets_store.dart';
import 'oauth_provider.dart';

// Persists OAuth refresh tokens via the existing M1 SecretsStore
// (flutter_secure_storage). Access tokens stay in memory only — never on disk.
//
// One bundle per account: callers identify the account by its int id.

class OAuthTokenStore {
  OAuthTokenStore({required this.secrets});

  final SecretsStore secrets;

  static const _refreshSlot = 'refresh_token';
  static const _expirySlot = 'access_token_expiry';

  Future<void> persist({
    required int accountId,
    required AuthBundle bundle,
  }) async {
    if (bundle.refreshToken != null) {
      await secrets.write(accountId, _refreshSlot, bundle.refreshToken!);
    }
    await secrets.write(
      accountId,
      _expirySlot,
      bundle.expiresAt.toUtc().toIso8601String(),
    );
  }

  Future<String?> readRefreshToken(int accountId) =>
      secrets.read(accountId, _refreshSlot);

  Future<DateTime?> readExpiry(int accountId) async {
    final raw = await secrets.read(accountId, _expirySlot);
    if (raw == null) {
      return null;
    }
    return DateTime.tryParse(raw);
  }

  Future<void> wipe(int accountId) => secrets.deleteAccount(accountId);
}
