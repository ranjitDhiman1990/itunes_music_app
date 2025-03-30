import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/core/services/player_state.dart';

class PlayerNotifier extends StateNotifier<PlayerState> {
  PlayerNotifier() : super(const PlayerState());

  void play(String songId) {
    state = state.copyWith(currentSongId: songId, isPlaying: true);
  }

  void pause() {
    state = state.copyWith(isPlaying: false);
  }

  void stop() {
    state = const PlayerState();
  }
}
