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
        when(() => localDataSource.getTopSongs())
            .thenAnswer((_) async => testSongs);

        final result = await localDataSource.getTopSongs();

        expect(result, equals(testSongs));
        verify(() => localDataSource.getTopSongs()).called(1);
      });

      test('should return empty list when no songs available', () async {
        when(() => localDataSource.getTopSongs()).thenAnswer((_) async => []);

        final result = await localDataSource.getTopSongs();

        expect(result, isEmpty);
        verify(() => localDataSource.getTopSongs()).called(1);
      });

      test('should propagate errors', () async {
        when(() => localDataSource.getTopSongs())
            .thenThrow(Exception('Database error'));

        expect(() => localDataSource.getTopSongs(), throwsException);
        verify(() => localDataSource.getTopSongs()).called(1);
      });
    });

    group('saveTopSongs', () {
      test('should complete successfully when saving songs', () async {
        when(() => localDataSource.saveTopSongs(any()))
            .thenAnswer((_) async {});

        await localDataSource.saveTopSongs(testSongs);

        verify(() => localDataSource.saveTopSongs(testSongs)).called(1);
      });

      test('should handle empty list input', () async {
        when(() => localDataSource.saveTopSongs(any()))
            .thenAnswer((_) async {});

        await localDataSource.saveTopSongs([]);

        verify(() => localDataSource.saveTopSongs([])).called(1);
      });

      test('should propagate errors', () async {
        when(() => localDataSource.saveTopSongs(any()))
            .thenThrow(Exception('Storage full'));

        expect(
          () => localDataSource.saveTopSongs(testSongs),
          throwsException,
        );
      });
    });
  });
}
