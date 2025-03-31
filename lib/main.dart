import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/app/app.dart';
import 'package:itunes_music_app/core/services/notification_service/notification_service.dart';
import 'package:itunes_music_app/core/services/notification_service/permission_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await AppPermissions.checkAndRequestNotificationPermission();
    await NotificationService.initialize();
  }

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
