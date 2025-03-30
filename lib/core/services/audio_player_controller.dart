import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/core/providers/providers.dart';

class AudioPlayerController {
  final AudioPlayer _player = AudioPlayer();
  final Ref ref;

  AudioPlayerController(this.ref);

  Future<void> play(String songId, String url) async {
    ref.read(playerProvider.notifier).play(songId);
    await _player.play(UrlSource(url));
  }

  Future<void> pause() async {
    ref.read(playerProvider.notifier).pause();
    await _player.pause();
  }

  Future<void> stop() async {
    ref.read(playerProvider.notifier).stop();
    await _player.stop();
  }

  void dispose() => _player.dispose();
}
