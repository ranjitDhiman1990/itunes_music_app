import 'package:flutter/foundation.dart';
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

  Map<String, SongEntity> get songsMap {
    return {for (var song in songs) song.id: song};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          listEquals(songs, other.songs) &&
          error == other.error;

  @override
  int get hashCode => isLoading.hashCode ^ songs.hashCode ^ error.hashCode;

  @override
  String toString() => 'SongState(isLoading: $isLoading, '
      'songs: ${songs.length}, error: $error)';
}
