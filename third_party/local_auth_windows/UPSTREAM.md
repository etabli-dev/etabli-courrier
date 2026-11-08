# Upstream and local patch

Source: https://pub.dev/api/archives/local_auth_windows-1.0.11.tar.gz

Published archive SHA-256: `bc4e66a29b0fdf751aafbec923b5bed7ad6ed3614875d8151afe2578520b2ab5`. Version 1.0.11; retained BSD-3-Clause license and authorship.

Current MSVC rejects the legacy /await extension. The plugin already requires C++20; remove /await from its plugin and native-test targets, and use co_return for the UserConsentVerifier coroutine result. Dart APIs and Windows Hello behavior are unchanged. The application-level flag workaround is superseded by this complete source patch.

Keep source and license with distributions. Replace the path dependency when a compatible upstream implementation includes these standard-coroutine fixes; rerun Windows compilation and native authentication acceptance.
