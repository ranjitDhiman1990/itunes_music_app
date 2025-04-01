import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/core/providers/providers.dart';
import 'package:itunes_music_app/core/services/audio_player/player_state.dart';
import 'package:itunes_music_app/features/cart/presentation/states/cart_state.dart';
import 'package:itunes_music_app/features/cart/presentation/view_models/cart_view_model.dart';
import 'package:itunes_music_app/features/songs/presentation/view_models/song_controller.dart';
import 'package:mocktail/mocktail.dart';

class MockWidgetRef extends Mock implements WidgetRef {}

class MockCartState extends Mock implements CartState {}

class MockPlayerState extends Mock implements PlayerState {}

void main() {
  late MockWidgetRef mockRef;
  late MockCartState mockCartState;
  late MockPlayerState mockPlayerState;
  late SongController songController;
  const songId = '123';

  setUp(() {
    mockRef = MockWidgetRef();
    mockCartState = MockCartState();
    mockPlayerState = MockPlayerState();

    when(() => mockRef.watch(playerProvider)).thenReturn(mockPlayerState);
    when(() => mockRef.watch(cartViewModel)).thenReturn(mockCartState);

    songController = SongController(mockRef, songId);
  });

  test('isPlaying returns true when the current song is playing', () {
    when(() => mockPlayerState.currentSongId).thenReturn(songId);
    when(() => mockPlayerState.isPlaying).thenReturn(true);

    expect(songController.isPlaying, true);
  });

  test('isPlaying returns false when the song is not playing', () {
    when(() => mockPlayerState.isPlaying).thenReturn(false);
    expect(songController.isPlaying, false);
  });

  test('isInCart returns true when song is in cart', () {
    when(() => mockCartState.isInCart(songId)).thenReturn(true);
    expect(songController.isInCart, true);
  });

  test('isInCart returns false when song is not in cart', () {
    when(() => mockCartState.isInCart(songId)).thenReturn(false);
    expect(songController.isInCart, false);
  });
}
