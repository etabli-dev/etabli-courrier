package com.dexterous.flutterlocalnotifications;

import static org.junit.Assert.*;
import static org.robolectric.Shadows.shadowOf;
import android.Manifest;
import android.app.Application;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import androidx.core.app.NotificationManagerCompat;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.RuntimeEnvironment;
import org.robolectric.annotation.Config;

@RunWith(RobolectricTestRunner.class)
@Config(sdk = 33)
public class NotificationPosterTest {
  private void exercise(boolean granted, boolean expected) {
    Application app = RuntimeEnvironment.getApplication();
    if (granted) shadowOf(app).grantPermissions(Manifest.permission.POST_NOTIFICATIONS);
    else shadowOf(app).denyPermissions(Manifest.permission.POST_NOTIFICATIONS);
    NotificationManager nativeManager = (NotificationManager) app.getSystemService(Context.NOTIFICATION_SERVICE);
    nativeManager.createNotificationChannel(new NotificationChannel("test", "Test", NotificationManager.IMPORTANCE_DEFAULT));
    Notification notification = new Notification.Builder(app, "test").setContentTitle("Reminder").setSmallIcon(android.R.drawable.ic_dialog_info).build();
    boolean posted = NotificationPoster.post(app, NotificationManagerCompat.from(app), null, 42, notification);
    assertEquals(expected, posted);
    assertEquals(expected, shadowOf(nativeManager).getNotification(42) != null);
  }
  @Test public void deniedPermissionDoesNotPost() { exercise(false, false); }
  @Test public void grantedPermissionPosts() { exercise(true, true); }
  @Test @Config(sdk = 28) public void olderAndroidDoesNotRequireRuntimeNotificationPermission() { exercise(false, true); }
}
