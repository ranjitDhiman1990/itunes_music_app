import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/core/providers/providers.dart';
import 'package:itunes_music_app/core/services/audio_player/audio_player_controller.dart';
import 'package:itunes_music_app/core/services/audio_player/player_notifier.dart';
import 'package:itunes_music_app/core/services/audio_player/player_state.dart';
import 'package:itunes_music_app/core/utils/common_imageview_widget.dart';
import 'package:itunes_music_app/features/cart/presentation/states/cart_state.dart';
import 'package:itunes_music_app/features/cart/presentation/view_models/cart_view_model.dart';
import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';
import 'package:itunes_music_app/features/songs/presentation/views/widgets/song_item.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'song_item_test.mocks.dart';

// Generate mocks
@GenerateMocks([
  CartViewModel,
  AudioPlayerController,
  PlayerNotifier,
], customMocks: [
  MockSpec<CartState>(unsupportedMembers: {#copyWith}),
])
void main() {
  late MockCartViewModel mockCartViewModel;
  late MockAudioPlayerController mockAudioController;
  late MockPlayerNotifier mockPlayerNotifier;
  late CartState cartState;

  var testSong = SongEntity(
    id: '123',
    title: 'Test Song',
    artist: 'Test Artist',
    imgURL: 'https://example.com/image.jpg',
    previewURL: 'https://example.com/preview.mp3',
  );

  setUp(() {
    mockCartViewModel = MockCartViewModel();
    mockAudioController = MockAudioPlayerController();
    mockPlayerNotifier = MockPlayerNotifier();
    cartState = CartState(cartItems: []);

    // Setup default mock behavior
    when(mockCartViewModel.state).thenReturn(cartState);
    when(mockCartViewModel.addListener(any,
            fireImmediately: anyNamed('fireImmediately')))
        .thenReturn(() {});
    when(mockPlayerNotifier.state).thenReturn(const PlayerState(
      currentSongId: null,
      isPlaying: false,
    ));
  });

  Widget createWidgetUnderTest({SongEntity? song, VoidCallback? onTap}) {
    return ProviderScope(
      overrides: [
        cartViewModel.overrideWith((ref) => mockCartViewModel),
        playerProvider.overrideWith((ref) => mockPlayerNotifier),
        audioControllerProvider.overrideWith((ref) => mockAudioController),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SongItemWidget(
            song: song ?? testSong,
            onTap: onTap ?? () {},
          ),
        ),
      ),
    );
  }

  group('SongItemWidget', () {
    testWidgets('renders correctly with all song details', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Test Song'), findsOneWidget);
      expect(find.text('Test Artist'), findsOneWidget);
      expect(find.byType(CommonImageViewWidget), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
    });

    testWidgets('shows pause icon when current song is playing',
        (tester) async {
      when(mockPlayerNotifier.state.currentSongId).thenReturn('123');
      when(mockPlayerNotifier.state.isPlaying).thenReturn(true);

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byIcon(Icons.pause), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsNothing);
    });

    testWidgets('shows remove cart icon when song is in cart', (tester) async {
      when(cartState.isInCart('123')).thenReturn(true);

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byIcon(Icons.remove_shopping_cart), findsOneWidget);
      expect(find.byIcon(Icons.add_shopping_cart), findsNothing);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        createWidgetUnderTest(onTap: () => tapped = true),
      );

      await tester.tap(find.byType(ListTile));
      expect(tapped, isTrue);
    });

    testWidgets('plays song when play button is pressed', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.play_arrow));
      verify(mockAudioController.play(
        '123',
        'https://example.com/preview.mp3',
        'Test Song',
      )).called(1);
    });

    testWidgets('pauses song when pause button is pressed', (tester) async {
      when(mockPlayerNotifier.state.currentSongId).thenReturn('123');
      when(mockPlayerNotifier.state.isPlaying).thenReturn(true);

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.pause));
      verify(mockAudioController.pause()).called(1);
    });

    testWidgets('adds to cart when add button is pressed', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.add_shopping_cart));
      verify(mockCartViewModel.addToCart('123')).called(1);
    });

    // testWidgets('does nothing when play button pressed with no preview URL',
    //     (tester) async {
    //   await tester.pumpWidget(
    //     createWidgetUnderTest(
    //       song: testSong.copyWith(previewURL: null),
    //     ),
    //   );

    //   await tester.tap(find.byIcon(Icons.play_arrow));
    //   verifyNever(mockAudioController.play(any, any, any));
    // });
  });
}
