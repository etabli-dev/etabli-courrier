import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Per-account secret material — passwords, app-passwords, OAuth refresh tokens.
// AUDIT_LOOP dim 4 (security & privacy) requires every secret/token to live in
// platform secure storage and never appear in logs or shared_prefs.
class SecretsStore {
  SecretsStore({FlutterSecureStorage? backend})
    : _backend =
          backend ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  final FlutterSecureStorage _backend;

  // Slot naming convention: `<accountId>.<purpose>`. Purposes:
  //   * password           — IMAP/SMTP / Nextcloud app password
  //   * refresh_token      — OAuth refresh token (M8 Microsoft 365)
  //   * access_token       — short-lived OAuth access token (cached only)
  //   * access_token_expiry — ISO-8601 string
  String _slot(int accountId, String purpose) => '$accountId.$purpose';

  Future<void> write(int accountId, String purpose, String value) =>
      _backend.write(key: _slot(accountId, purpose), value: value);

  Future<String?> read(int accountId, String purpose) =>
      _backend.read(key: _slot(accountId, purpose));

  Future<void> deleteAccount(int accountId) async {
    final all = await _backend.readAll();
    final prefix = '$accountId.';
    for (final entry in all.entries) {
      if (entry.key.startsWith(prefix)) {
        await _backend.delete(key: entry.key);
      }
    }
  }

  Future<void> wipe() => _backend.deleteAll();
}
