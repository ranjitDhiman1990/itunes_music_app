import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:itunes_music_app/core/services/notification_service/permission_utils.dart';
import 'package:itunes_music_app/main.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    final hasPermission =
        await AppPermissions.checkAndRequestNotificationPermission();
    if (!hasPermission) return;

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'music_controls',
            'Music Controls',
            description: 'Media playback controls',
            importance: Importance.low,
            enableVibration: false,
            playSound: false,
          ),
        );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationResponse(response);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static void _handleNotificationResponse(NotificationResponse response) {
    debugPrint('Notification action triggered: ${response.actionId}');
    debugPrint('Notification payload: ${response.payload}');
    final action = response.actionId;
    if (action == 'play') {
      // Handle play action
    } else if (action == 'pause') {
      // Handle pause action
    }
  }

  static Future<void> showMediaNotification({
    required String title,
    required bool isPlaying,
  }) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'music_controls',
      'Music Controls',
      channelDescription: 'Media playback controls',
      importance: Importance.low,
      priority: Priority.low,
      playSound: false,
      enableVibration: false,
      ongoing: true,
      autoCancel: false,
      visibility: NotificationVisibility.public,
      actions: [
        AndroidNotificationAction(
          'pause',
          'Pause',
          icon: DrawableResourceAndroidBitmap('ic_pause'),
        ),
        AndroidNotificationAction(
          'play',
          'Play',
          icon: DrawableResourceAndroidBitmap('ic_play'),
        ),
      ],
    );

    await _notifications.show(
      0,
      title,
      'Now Playing',
      const NotificationDetails(android: androidPlatformChannelSpecifics),
    );
  }

  static Future<void> cancel() async {
    await _notifications.cancel(0);
  }
}
