import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/core/providers/providers.dart';
import 'package:itunes_music_app/core/services/notification_service/notification_service.dart';
import 'package:itunes_music_app/core/services/notification_service/permission_utils.dart';

class AudioPlayerController {
  final AudioPlayer _player = AudioPlayer();
  final Ref ref;

  AudioPlayerController(this.ref);

  Future<void> play(String songId, String url, String songTitle) async {
    if (!await AppPermissions.areNotificationsAllowed()) {
    // Optionally show a dialog to inform user
    return;
  }
    ref.read(playerProvider.notifier).play(songId);
    await _player.play(UrlSource(url));
    await NotificationService.showMediaNotification(
      title: songTitle,
      isPlaying: true,
    );
  }

  Future<void> pause() async {
    ref.read(playerProvider.notifier).pause();
    await _player.pause();
    await NotificationService.showMediaNotification(
      title: 'Paused',
      isPlaying: false,
    );
  }

  Future<void> resume() async {
    ref.read(playerProvider.notifier).resume();
    await _player.resume();
    await NotificationService.showMediaNotification(
      title: 'Resumed',
      isPlaying: false,
    );
  }

  Future<void> stop() async {
    ref.read(playerProvider.notifier).stop();
    await _player.stop();
    await NotificationService.cancel();
  }

  void dispose() {
    _player.dispose();
    NotificationService.cancel();
  }
}
