import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/core/services/audio_player/player_state.dart';

void main() {
  group('PlayerState', () {
    test('should create a default PlayerState', () {
      const state = PlayerState();
      expect(state.currentSongId, isNull);
      expect(state.isPlaying, isFalse);
    });

    test('should create a PlayerState with given values', () {
      const state = PlayerState(currentSongId: 'song_123', isPlaying: true);
      expect(state.currentSongId, 'song_123');
      expect(state.isPlaying, isTrue);
    });

    test('copyWith should update only specified properties', () {
      const state = PlayerState(currentSongId: 'song_123', isPlaying: false);
      final newState = state.copyWith(isPlaying: true);

      expect(newState.currentSongId, 'song_123');
      expect(newState.isPlaying, isTrue);
    });
  });
}
