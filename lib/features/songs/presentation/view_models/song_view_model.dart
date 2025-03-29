import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/core/providers/providers.dart';
import 'package:itunes_music_app/features/songs/domain/repositories/song_repository.dart';
import 'package:itunes_music_app/features/songs/presentation/states/song_state.dart';

final songViewModel = StateNotifierProvider<SongViewModel, SongState>((ref) {
  final repo = ref.read(songRepositoryProvider);
  return SongViewModel(repo);
});

class SongViewModel extends StateNotifier<SongState> {
  final SongRepository _repository;

  SongViewModel(this._repository) : super(SongState()) {
    loadSongs();
  }

  Future<void> loadSongs() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final songs = await _repository.getTopSongs();
      state = state.copyWith(songs: songs, isLoading: false);
    } catch (err) {
      state = state.copyWith(error: err.toString(), isLoading: false);
    }
  }
}
