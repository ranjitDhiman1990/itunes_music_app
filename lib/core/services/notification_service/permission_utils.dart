import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  static Future<bool> checkAndRequestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      final result = await Permission.notification.request();
      return result.isGranted;
    }
    return true;
  }

  static Future<bool> areNotificationsAllowed() async {
    return await Permission.notification.isGranted;
  }
}
