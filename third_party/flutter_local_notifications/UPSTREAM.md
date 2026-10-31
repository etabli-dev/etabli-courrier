# Upstream and local patch

Source: https://pub.dev/api/archives/flutter_local_notifications-22.3.3.tar.gz

Published archive SHA-256: `fd5fc8966a8b34337ac182dc394f3506139b69d8138d4e9e174a13d6468adcd4`. Upstream version 22.3.3, retained BSD-3-Clause license.

The Android NotificationPoster helper checks POST_NOTIFICATIONS on API 33+ and catches permission revocation between that check and posting. Both the current and legacy scheduled-receiver paths use it. No Dart/iOS/macOS behavior was changed. Android Robolectric tests exercise denied, granted and pre-runtime-permission cases. Retain this source and its license with distributions. Replace the path dependency with a compatible upstream version once equivalent handling is available, then rerun the native and application gates.
