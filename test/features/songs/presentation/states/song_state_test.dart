import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';
import 'package:itunes_music_app/features/songs/presentation/states/song_state.dart';

void main() {
  final testSong1 = SongEntity(id: '1', title: 'Song 1');
  final testSong2 = SongEntity(id: '2', title: 'Song 2');

  group('SongState', () {
    test('should have correct default values', () {
      final state = SongState();

      expect(state.isLoading, false);
      expect(state.songs, isEmpty);
      expect(state.error, isNull);
    });

    test('should maintain values when provided', () {
      final state = SongState(
        isLoading: true,
        songs: [testSong1, testSong2],
        error: 'Error occurred',
      );

      expect(state.isLoading, true);
      expect(state.songs, [testSong1, testSong2]);
      expect(state.error, 'Error occurred');
    });

    group('copyWith', () {
      test('should update songs list', () {
        final original = SongState(songs: [testSong1]);
        final copied = original.copyWith(songs: [testSong2]);

        expect(copied.songs, [testSong2]);
        expect(copied.isLoading, false); // Unchanged
      });
    });

    group('songsMap', () {
      test('should return empty map when no songs', () {
        final state = SongState();

        final map = state.songsMap;

        expect(map, isEmpty);
      });

      test('should create map with song IDs as keys', () {
        final state = SongState(songs: [testSong1, testSong2]);

        final map = state.songsMap;

        expect(map.length, 2);
        expect(map['1'], testSong1);
        expect(map['2'], testSong2);
      });

      test('should handle duplicate IDs by keeping last occurrence', () {
        final duplicateSong = SongEntity(id: '1', title: 'Duplicate');
        final state = SongState(songs: [testSong1, duplicateSong]);

        final map = state.songsMap;

        expect(map.length, 1);
        expect(map['1'], duplicateSong);
      });
    });
  });
}
