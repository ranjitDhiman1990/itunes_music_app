import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/features/cart/presentation/states/cart_state.dart';
import 'package:itunes_music_app/features/cart/presentation/view_models/cart_view_model.dart';
import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';
import 'package:itunes_music_app/features/songs/presentation/states/song_state.dart';
import 'package:itunes_music_app/features/songs/presentation/view_models/song_view_model.dart';
import 'package:itunes_music_app/features/songs/presentation/views/song_list_screen.dart';

import '../../../cart/domain/repositories/cart_repository_test.mocks.dart';
import '../view_models/song_view_model_test.mocks.dart';

class MockSongViewModel extends SongViewModel {
  MockSongViewModel() : super(MockSongRepository()) {
    state = SongState(
      isLoading: false,
      error: null,
      songs: [
        SongEntity(id: '1', title: 'Song 1', artist: 'Artist 1'),
        SongEntity(id: '2', title: 'Song 2', artist: 'Artist 2'),
        SongEntity(
          id: '123',
          title: 'Test Song',
          artist: 'Test Artist',
          album: 'Test Album',
          imgURL: 'https://example.com/song.jpg',
          previewURL: 'https://example.com/song.mp3',
        )
      ],
    );
  }
}

class MockCartViewModel extends CartViewModel {
  MockCartViewModel() : super(MockCartRepository()) {
    state =
        CartState(); // Assuming CartState takes totalItems as a positional argument
  }
}

void main() {
  testWidgets('SongListScreen displays a list of songs',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          songViewModel.overrideWith((ref) => MockSongViewModel()),
          cartViewModel.overrideWith((ref) => MockCartViewModel()),
        ],
        child: const MaterialApp(home: SongListScreen()),
      ),
    );

    // Verify list is rendered
    expect(find.text('Songs List'), findsOneWidget);
    expect(find.text('Song 1'), findsOneWidget);
    expect(find.text('Song 2'), findsOneWidget);
  });
}
