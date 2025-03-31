import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:itunes_music_app/core/services/audio_player/audio_player_controller.dart';
import 'package:itunes_music_app/core/services/notification_service/permission_utils.dart';

@pragma('vm:entry-point')
void notificationTapBackground(ReceivedAction receivedAction) {
  // This runs when app is in background/terminated
  debugPrint(
      'Background notification action: ${receivedAction.buttonKeyPressed}');
  debugPrint('Notification payload: ${receivedAction.payload}');
}

class NotificationService {
  static Future<void> initialize() async {
    final hasPermission =
        await AppPermissions.checkAndRequestNotificationPermission();
    if (!hasPermission) return;

    await AwesomeNotifications().initialize(
      null, // Use default app icon if null
      [
        NotificationChannel(
          channelKey: 'music_controls',
          channelName: 'Music Controls',
          channelDescription: 'Media playback controls',
          importance: NotificationImportance.Low,
          playSound: false,
          enableVibration: false,
          channelShowBadge: false,
        )
      ],
      debug: true,
    );

    // Set up notification action handlers
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _handleNotificationResponse,
      onNotificationCreatedMethod: _onNotificationCreated,
      onNotificationDisplayedMethod: _onNotificationDisplayed,
      onDismissActionReceivedMethod: _onDismissActionReceived,
    );
  }

  static Future<void> _onNotificationCreated(
      ReceivedNotification notification) async {
    debugPrint('Notification created: ${notification.id}');
  }

  static Future<void> _onNotificationDisplayed(
      ReceivedNotification notification) async {
    debugPrint('Notification displayed: ${notification.id}');
  }

  static Future<void> _onDismissActionReceived(ReceivedAction action) async {
    debugPrint('Notification dismissed: ${action.id}');
  }

  static Future<void> _handleNotificationResponse(ReceivedAction action) async {
    final controller = globalAudioController;
    final actionKey = action.buttonKeyPressed;
    if (actionKey == 'play') {
      controller?.resume();
    } else if (actionKey == 'pause') {
      controller?.pause();
    }
  }

  static Future<void> showMediaNotification({
    required String title,
    required bool isPlaying,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'music_controls',
        title: title,
        body: 'Now Playing',
        payload: {'media': 'music'},
        notificationLayout: NotificationLayout.Default,
        criticalAlert: true,
        locked: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'pause',
          label: 'Pause',
          icon: 'resource://drawable/ic_pause',
        ),
        NotificationActionButton(
          key: 'play',
          label: 'Play',
          icon: 'resource://drawable/ic_play',
        ),
      ],
    );
  }

  static Future<void> cancel() async {
    await AwesomeNotifications().cancel(0);
  }

  static Future<void> dispose() async {
    await AwesomeNotifications().dispose();
  }
}
