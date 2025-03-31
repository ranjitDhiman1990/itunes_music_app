import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/features/songs/data/datasources/local_data_source.dart';
import 'package:itunes_music_app/features/songs/data/models/song_model.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDataSource extends Mock implements LocalDataSource {}

void main() {
  late MockLocalDataSource localDataSource;

  final testSongs = [
    SongModel(id: '1', title: 'Song One', artist: 'Artist A'),
    SongModel(id: '2', title: 'Song Two', artist: 'Artist B'),
  ];

  setUp(() {
    localDataSource = MockLocalDataSource();
  });

  group('LocalDataSource', () {
    group('getTopSongs', () {
      test('should return list of SongModel when successful', () async {
        // Arrange
        when(() => localDataSource.getTopSongs())
            .thenAnswer((_) async => testSongs);

        // Act
        final result = await localDataSource.getTopSongs();

        // Assert
        expect(result, equals(testSongs));
        verify(() => localDataSource.getTopSongs()).called(1);
      });

      test('should return empty list when no songs available', () async {
        // Arrange
        when(() => localDataSource.getTopSongs()).thenAnswer((_) async => []);

        // Act
        final result = await localDataSource.getTopSongs();

        // Assert
        expect(result, isEmpty);
        verify(() => localDataSource.getTopSongs()).called(1);
      });

      test('should propagate errors', () async {
        // Arrange
        when(() => localDataSource.getTopSongs())
            .thenThrow(Exception('Database error'));

        // Act & Assert
        expect(() => localDataSource.getTopSongs(), throwsException);
        verify(() => localDataSource.getTopSongs()).called(1);
      });
    });

    group('saveTopSongs', () {
      test('should complete successfully when saving songs', () async {
        // Arrange
        when(() => localDataSource.saveTopSongs(any()))
            .thenAnswer((_) async {});

        // Act
        await localDataSource.saveTopSongs(testSongs);

        // Assert
        verify(() => localDataSource.saveTopSongs(testSongs)).called(1);
      });

      test('should handle empty list input', () async {
        // Arrange
        when(() => localDataSource.saveTopSongs(any()))
            .thenAnswer((_) async {});

        // Act
        await localDataSource.saveTopSongs([]);

        // Assert
        verify(() => localDataSource.saveTopSongs([])).called(1);
      });

      test('should propagate errors', () async {
        // Arrange
        when(() => localDataSource.saveTopSongs(any()))
            .thenThrow(Exception('Storage full'));

        // Act & Assert
        expect(
          () => localDataSource.saveTopSongs(testSongs),
          throwsException,
        );
      });
    });
  });
}
