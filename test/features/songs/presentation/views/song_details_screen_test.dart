import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/core/utils/common_imageview_widget.dart';
import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';
import 'package:itunes_music_app/features/songs/presentation/view_models/song_controller.dart';
import 'package:itunes_music_app/features/songs/presentation/views/song_details_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockSongController extends Mock implements SongController {}

// class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockSongController mockSongController;
  // late MockBuildContext mockBuildContext;
  late SongEntity songEntity;

  setUp(() {
    mockSongController = MockSongController();
    // mockBuildContext = MockBuildContext();
    songEntity = SongEntity(
      id: '123',
      title: 'Title Song',
      artist: 'Song Artist',
      album: 'Test Album',
      imgURL: 'http://example.com/image.png',
      previewURL: 'http://example.com/preview.mp3',
    );
    registerFallbackValue(songEntity);
    when(() => mockSongController.isInCart).thenReturn(false);
    when(() => mockSongController.isPlaying).thenReturn(false);
  });

  testWidgets('Display Song details Properly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SongDetailsView(
          song: songEntity,
          controller: mockSongController,
        ),
      ),
    );

    expect(find.text('Title Song'), findsNWidgets(1));
    expect(find.text('Song Artist'), findsOneWidget);
    expect(find.text('Album: Test Album'), findsOneWidget);
    expect(find.byType(CommonImageViewWidget), findsOneWidget);
    expect(find.text('Add to Cart'), findsOneWidget);
    expect(find.text('Play Song'), findsOneWidget);
  });

  testWidgets('SongDetailsView displays Remove from cart when item is in cart',
      (WidgetTester tester) async {
    when(() => mockSongController.isInCart).thenReturn(true);

    await tester.pumpWidget(
      MaterialApp(
        home: SongDetailsView(song: songEntity, controller: mockSongController),
      ),
    );

    expect(find.text('Remove from Cart'), findsOneWidget);
  });

  testWidgets('SongDetailsView displays Pause Song when song is playing',
      (WidgetTester tester) async {
    when(() => mockSongController.isPlaying).thenReturn(true);

    await tester.pumpWidget(
      MaterialApp(
        home: SongDetailsView(song: songEntity, controller: mockSongController),
      ),
    );

    expect(find.text('Pause Song'), findsOneWidget);
  });

  /*testWidgets('SongDetailsView calls toggleCartStatus when button is pressed',
      (WidgetTester tester) async {
    when(() =>
            mockSongController.toggleCartStatus(songEntity, mockBuildContext))
        .thenAnswer((_) async {});

    await tester.pumpWidget(
      MaterialApp(
        home: SongDetailsView(song: songEntity, controller: mockSongController),
      ),
    );

    await tester.tap(find.text('Add to Cart'));
    await tester.pump();

    verify(() =>
            mockSongController.toggleCartStatus(songEntity, mockBuildContext))
        .called(1);
  });*/

  testWidgets('SongDetailsView calls togglePlayPause when button is pressed',
      (WidgetTester tester) async {
    when(() => mockSongController.togglePlayPause(songEntity))
        .thenAnswer((_) {});

    await tester.pumpWidget(
      MaterialApp(
        home: SongDetailsView(song: songEntity, controller: mockSongController),
      ),
    );

    await tester.tap(find.text('Play Song'));
    await tester.pump();

    verify(() => mockSongController.togglePlayPause(songEntity)).called(1);
  });
}
