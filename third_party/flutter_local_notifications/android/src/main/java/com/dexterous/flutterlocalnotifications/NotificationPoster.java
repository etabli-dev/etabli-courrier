package com.dexterous.flutterlocalnotifications;

import android.Manifest;
import android.app.Notification;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.content.ContextCompat;

/** Permission can change after a reminder was scheduled. */
final class NotificationPoster {
  private NotificationPoster() {}

  static boolean post(Context context, NotificationManagerCompat manager,
      String tag, int id, Notification notification) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU
        && ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS)
            != PackageManager.PERMISSION_GRANTED) {
      return false;
    }
    try {
      manager.notify(tag, id, notification);
      return true;
    } catch (SecurityException permissionRevoked) {
      Log.w("NotificationPoster", "Notification permission was revoked before delivery.");
      return false;
    }
  }
}
