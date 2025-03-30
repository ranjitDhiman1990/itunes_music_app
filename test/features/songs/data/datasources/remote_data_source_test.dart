import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/features/songs/data/models/song_model.dart';
import 'package:mockito/annotations.dart';
import 'package:itunes_music_app/features/songs/data/datasources/remote_data_source.dart';
import 'package:mockito/mockito.dart';

import 'remote_data_source_test.mocks.dart';

@GenerateMocks([RemoteDataSource])
void main() {
  late MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
  });

  List<SongModel> testTopSongs = [
    SongModel(
      id: '100',
      title: 'Kesariya',
      artist: 'Arijit Singh',
      album: 'Brahmastra',
      imgURL: 'https://example.com/image.jpg',
      previewURL: 'https://example.com/preview.mp3',
    ),
    SongModel(
      id: '101',
      title: 'Raza',
      artist: 'Salman Elahi',
      album: 'Elahi, 2025',
      imgURL: 'https://example.com/image1.jpg',
      previewURL: 'https://example.com/preview1.mp3',
    )
  ];

  test('Fetch Top Songs', () async {
    // Arrange
    when(mockRemoteDataSource.getTopSongs())
        .thenAnswer((_) async => testTopSongs);

    // Act
    final result = await mockRemoteDataSource.getTopSongs();

    // Assert
    expect(result, testTopSongs);
    verify(mockRemoteDataSource.getTopSongs()).called(1);
  });

  test('Failed to Fetch Top Songs', () async {
    // Arrange
    const errorMessage = 'Failed to load songs';
    when(mockRemoteDataSource.getTopSongs()).thenThrow(Exception(errorMessage));

    // Act & Assert
    expect(() => mockRemoteDataSource.getTopSongs(), throwsA(isA<Exception>()));
    verify(mockRemoteDataSource.getTopSongs()).called(1);
  });
}
