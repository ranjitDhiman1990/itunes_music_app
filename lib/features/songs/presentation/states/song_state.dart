import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';

class SongState {
  final bool isLoading;
  final List<SongEntity> songs;
  final String? error;

  SongState({
    this.isLoading = false,
    this.songs = const [],
    this.error,
  });

  SongState copyWith({
    bool? isLoading,
    List<SongEntity>? songs,
    String? error,
  }) {
    return SongState(
      isLoading: isLoading ?? this.isLoading,
      songs: songs ?? this.songs,
      error: error ?? this.error,
    );
  }
}
