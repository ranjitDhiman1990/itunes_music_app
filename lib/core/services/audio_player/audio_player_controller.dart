import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/core/providers/providers.dart';
import 'package:itunes_music_app/core/services/notification_service/notification_service.dart';
import 'package:itunes_music_app/core/services/notification_service/permission_utils.dart';

AudioPlayerController? _globalAudioController;

void setGlobalAudioController(AudioPlayerController controller) {
  _globalAudioController = controller;
}

AudioPlayerController? get globalAudioController => _globalAudioController;

class AudioPlayerController {
  final AudioPlayer _player = AudioPlayer();
  final Ref ref;

  AudioPlayerController(this.ref);

  Future<void> play(String songId, String url, String songTitle) async {
    if (Platform.isAndroid) {
      if (!await AppPermissions.areNotificationsAllowed()) {
        // Optionally show a dialog to inform user
        return;
      }
    }

    ref.read(playerProvider.notifier).play(songId);
    await _player.play(UrlSource(url));
    if (Platform.isAndroid) {
      await NotificationService.showMediaNotification(
        title: songTitle,
        isPlaying: true,
      );
    }
  }

  Future<void> pause() async {
    ref.read(playerProvider.notifier).pause();
    await _player.pause();
    if (Platform.isAndroid) {
      await NotificationService.showMediaNotification(
        title: 'Paused',
        isPlaying: false,
      );
    }
  }

  Future<void> resume() async {
    ref.read(playerProvider.notifier).resume();
    await _player.resume();
    if (Platform.isAndroid) {
      await NotificationService.showMediaNotification(
        title: 'Resumed',
        isPlaying: false,
      );
    }
  }

  Future<void> stop() async {
    ref.read(playerProvider.notifier).stop();
    await _player.stop();
    if (Platform.isAndroid) {
      await NotificationService.cancel();
    }
  }

  void dispose() {
    _player.dispose();
    if (Platform.isAndroid) {
      NotificationService.cancel();
    }
  }
}
