import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';
import 'package:itunes_music_app/features/songs/presentation/states/song_state.dart';

void main() {
  final testSong1 = SongEntity(id: '1', title: 'Song 1');
  final testSong2 = SongEntity(id: '2', title: 'Song 2');

  group('SongState', () {
    test('should have correct default values', () {
      // Act
      final state = SongState();

      // Assert
      expect(state.isLoading, false);
      expect(state.songs, isEmpty);
      expect(state.error, isNull);
    });

    test('should maintain values when provided', () {
      // Act
      final state = SongState(
        isLoading: true,
        songs: [testSong1, testSong2],
        error: 'Error occurred',
      );

      // Assert
      expect(state.isLoading, true);
      expect(state.songs, [testSong1, testSong2]);
      expect(state.error, 'Error occurred');
    });

    group('copyWith', () {
      test('should update songs list', () {
        // Arrange
        final original = SongState(songs: [testSong1]);

        // Act
        final copied = original.copyWith(songs: [testSong2]);

        // Assert
        expect(copied.songs, [testSong2]);
        expect(copied.isLoading, false); // Unchanged
      });
    });

    group('songsMap', () {
      test('should return empty map when no songs', () {
        // Arrange
        final state = SongState();

        // Act
        final map = state.songsMap;

        // Assert
        expect(map, isEmpty);
      });

      test('should create map with song IDs as keys', () {
        // Arrange
        final state = SongState(songs: [testSong1, testSong2]);

        // Act
        final map = state.songsMap;

        // Assert
        expect(map.length, 2);
        expect(map['1'], testSong1);
        expect(map['2'], testSong2);
      });

      test('should handle duplicate IDs by keeping last occurrence', () {
        // Arrange
        final duplicateSong = SongEntity(id: '1', title: 'Duplicate');
        final state = SongState(songs: [testSong1, duplicateSong]);

        // Act
        final map = state.songsMap;

        // Assert
        expect(map.length, 1);
        expect(map['1'], duplicateSong);
      });
    });
  });
}
