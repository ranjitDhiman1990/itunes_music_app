import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';
import 'package:itunes_music_app/features/songs/domain/repositories/song_repository.dart';
import 'package:itunes_music_app/features/songs/presentation/view_models/song_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'song_view_model_test.mocks.dart';

@GenerateMocks([SongRepository])
void main() {
  late SongViewModel viewModel;
  late MockSongRepository mockRepository;
  late List<SongEntity> testSongs;

  setUp(() {
    mockRepository = MockSongRepository();
    testSongs = [
      SongEntity(id: '1', title: 'Song 1'),
      SongEntity(id: '2', title: 'Song 2'),
    ];
    // Basic stub for initialization
    when(mockRepository.getTopSongs()).thenAnswer((_) async => []);
    viewModel = SongViewModel(mockRepository);
  });

  group('loadSongs', () {
    setUp(() {
      reset(mockRepository);
    });

    test('should set loading state when starting', () async {
      // Arrange
      final completer = Completer<List<SongEntity>>();
      when(mockRepository.getTopSongs()).thenAnswer((_) => completer.future);

      // Act
      final future = viewModel.loadSongs();

      // Assert
      expect(viewModel.state.isLoading, true);

      // Cleanup
      completer.complete([]);
      await future;
    });

    test('should update state with songs on successful load', () async {
      // Arrange
      when(mockRepository.getTopSongs()).thenAnswer((_) async => testSongs);

      // Act
      await viewModel.loadSongs();

      // Assert
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.error, isNull);
      expect(viewModel.state.songs, testSongs);
      verify(mockRepository.getTopSongs()).called(1);
    });

    test('should handle empty song list from repository', () async {
      // Arrange
      when(mockRepository.getTopSongs()).thenAnswer((_) async => []);

      // Act
      await viewModel.loadSongs();

      // Assert
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.songs, isEmpty);
    });

    test('should set error state when repository throws exception', () async {
      // Arrange
      const errorMessage = 'Failed to load songs';
      when(mockRepository.getTopSongs()).thenThrow(Exception(errorMessage));

      // Act
      await viewModel.loadSongs();

      // Assert
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.error, contains(errorMessage));
      expect(viewModel.state.songs, isEmpty);
    });
  });
}
