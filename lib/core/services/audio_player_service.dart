import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _playingURL;

  Future<void> play(String url) async {
    if (_playingURL == url) {
      await _audioPlayer.resume();
    } else {
      _playingURL = url;
      await _audioPlayer.play(UrlSource(url));
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _playingURL = null;
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
