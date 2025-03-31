import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/core/database/app_database.dart';
import 'package:itunes_music_app/features/songs/data/models/song_model.dart';
import 'package:itunes_music_app/features/songs/data/datasources/local_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'local_data_source_test.mocks.dart';

@GenerateMocks([AppDatabase, Database, Batch])
void main() {
  late LocalDataSourceImpl localDataSource;
  late MockAppDatabase mockAppDatabase;
  late MockDatabase mockDatabase;
  late MockBatch mockBatch;

  final testSongs = [
    SongModel(
      id: '1',
      title: 'Test Song 1',
      artist: 'Artist 1',
      previewURL: 'https://example.com/1',
      imgURL: 'https://example.com/image1.jpg',
    ),
    SongModel(
      id: '2',
      title: 'Test Song 2',
      artist: 'Artist 2',
      previewURL: 'https://example.com/2',
      imgURL: 'https://example.com/image2.jpg',
    ),
  ];

  setUp(() {
    mockAppDatabase = MockAppDatabase();
    mockDatabase = MockDatabase();
    mockBatch = MockBatch();

    localDataSource = LocalDataSourceImpl(appDatabase: mockAppDatabase);

    // Common setup for database access
    when(mockAppDatabase.database).thenAnswer((_) async => mockDatabase);
  });

  group('getTopSongs', () {
    test('should return list of songs when database query is successful',
        () async {
      final mockMaps = [
        {
          'id': '1',
          'title': 'Test Song 1',
          'artist': 'Artist 1',
          'genre': 'Pop',
          'previewUrl': 'https://example.com/1',
          'rights': '© 2023',
          'imageUrls': '["https://example.com/image1.jpg"]',
        },
        {
          'id': '2',
          'title': 'Test Song 2',
          'artist': 'Artist 2',
          'genre': 'Rock',
          'previewUrl': 'https://example.com/2',
          'rights': '© 2023',
          'imageUrls': '["https://example.com/image2.jpg"]',
        },
      ];

      when(mockDatabase.query('top_songs')).thenAnswer((_) async => mockMaps);

      final result = await localDataSource.getTopSongs();

      expect(result, isA<List<SongModel>>());
      expect(result.length, 2);
      expect(result[0].title, 'Test Song 1');
      expect(result[1].artist, 'Artist 2');
      verify(mockDatabase.query('top_songs')).called(1);
    });

    test('should return empty list when no songs exist in database', () async {
      when(mockDatabase.query('top_songs')).thenAnswer((_) async => []);

      final result = await localDataSource.getTopSongs();

      expect(result, isEmpty);
      verify(mockDatabase.query('top_songs')).called(1);
    });

    test('should throw exception when database query fails', () async {
      when(mockDatabase.query('top_songs'))
          .thenThrow(Exception('Database error'));

      expect(() => localDataSource.getTopSongs(), throwsException);
    });
  });

  group('saveTopSongs', () {
    test('should save songs using batch operation', () async {
      when(mockDatabase.batch()).thenReturn(mockBatch);
      when(mockBatch.commit()).thenAnswer((_) async => []);

      await localDataSource.saveTopSongs(testSongs);

      verify(mockDatabase.batch()).called(1);
      verify(mockBatch.insert(
        'top_songs',
        testSongs[0].toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )).called(1);
      verify(mockBatch.insert(
        'top_songs',
        testSongs[1].toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )).called(1);
      verify(mockBatch.commit()).called(1);
      verifyNoMoreInteractions(mockBatch);
    });

    test('should throw exception when batch commit fails', () async {
      when(mockDatabase.batch()).thenReturn(mockBatch);
      when(mockBatch.commit()).thenThrow(Exception('Commit failed'));

      expect(() => localDataSource.saveTopSongs(testSongs), throwsException);
    });

    test('should handle empty list without errors', () async {
      when(mockDatabase.batch()).thenReturn(mockBatch);
      when(mockBatch.commit()).thenAnswer((_) async => []);

      await localDataSource.saveTopSongs([]);

      verify(mockDatabase.batch()).called(1);
      verify(mockBatch.commit()).called(1);
      verifyNoMoreInteractions(mockBatch);
    });
  });
}
