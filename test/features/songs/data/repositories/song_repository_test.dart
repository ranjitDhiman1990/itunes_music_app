import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/features/songs/data/datasources/local_data_source.dart';
import 'package:itunes_music_app/features/songs/data/datasources/remote_data_source.dart';
import 'package:itunes_music_app/features/songs/data/models/song_model.dart';
import 'package:itunes_music_app/features/songs/data/repositories/song_repository.dart';
import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'song_repository_test.mocks.dart';

@GenerateMocks([RemoteDataSource, LocalDataSource])
void main() {
  late SongRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;

  final testSongModels = [
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

  final testSongEntities = testSongModels.map((e) => e.toEntity()).toList();

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = SongRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('getTopSongs', () {
    test('should return local songs when local data source has data', () async {
      // Arrange
      when(mockLocalDataSource.getTopSongs())
          .thenAnswer((_) async => testSongModels);

      // Act
      final result = await repository.getTopSongs();

      // Assert
      expect(result, testSongEntities);
      verify(mockLocalDataSource.getTopSongs());
      verifyNever(mockRemoteDataSource.getTopSongs());
      verifyNever(mockLocalDataSource.saveTopSongs(any));
    });

    test('should fetch from remote and save to local when local is empty',
        () async {
      // Arrange
      when(mockLocalDataSource.getTopSongs()).thenAnswer((_) async => []);
      when(mockRemoteDataSource.getTopSongs())
          .thenAnswer((_) async => testSongModels);
      when(mockLocalDataSource.saveTopSongs(any)).thenAnswer((_) async => []);
      when(mockLocalDataSource.getTopSongs())
          .thenAnswer((_) async => testSongModels);

      // Act
      final result = await repository.getTopSongs();

      // Assert
      expect(result, testSongEntities);
      verify(mockLocalDataSource.getTopSongs()).called(2);
      verify(mockRemoteDataSource.getTopSongs());
      verify(mockLocalDataSource.saveTopSongs(testSongModels));
    });

    test('should throw error when both local and remote fail', () async {
      // Arrange
      when(mockLocalDataSource.getTopSongs())
          .thenThrow(Exception('Local error'));
      when(mockRemoteDataSource.getTopSongs())
          .thenThrow(Exception('Remote error'));

      // Act & Assert
      expect(() => repository.getTopSongs(), throwsA(isA<String>()));
      verify(mockLocalDataSource.getTopSongs());
      verify(mockRemoteDataSource.getTopSongs());
      verifyNever(mockLocalDataSource.saveTopSongs(any));
    });

    test('should return remote songs and save to local when local is empty',
        () async {
      // Arrange
      when(mockLocalDataSource.getTopSongs()).thenAnswer((_) async => []);
      when(mockRemoteDataSource.getTopSongs())
          .thenAnswer((_) async => testSongModels);
      when(mockLocalDataSource.saveTopSongs(testSongModels))
          .thenAnswer((_) async => []);
      when(mockLocalDataSource.getTopSongs())
          .thenAnswer((_) async => testSongModels);

      // Act
      final result = await repository.getTopSongs();

      // Assert
      expect(result, testSongEntities);
      verify(mockLocalDataSource.getTopSongs()).called(2);
      verify(mockRemoteDataSource.getTopSongs());
      verify(mockLocalDataSource.saveTopSongs(testSongModels));
    });

    test(
        'should handle error from remote and return empty list if local is empty',
        () async {
      // Arrange
      when(mockLocalDataSource.getTopSongs()).thenAnswer((_) async => []);
      when(mockRemoteDataSource.getTopSongs())
          .thenThrow(Exception('Remote error'));

      // Act & Assert
      expect(() => repository.getTopSongs(), throwsA(isA<String>()));
      verify(mockLocalDataSource.getTopSongs());
      verify(mockRemoteDataSource.getTopSongs());
      verifyNever(mockLocalDataSource.saveTopSongs(any));
    });
  });
}
