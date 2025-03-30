import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/app/app.dart';
import 'package:itunes_music_app/core/services/notification_service/notification_service.dart';
import 'package:itunes_music_app/core/services/notification_service/permission_utils.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  // This runs when app is in background/terminated
  // You might want to save the action and handle when app resumes
  debugPrint('Background notification action: ${response.actionId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPermissions.checkAndRequestNotificationPermission();
  await NotificationService.initialize();
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
