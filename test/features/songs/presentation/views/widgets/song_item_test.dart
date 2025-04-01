import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';
import 'package:itunes_music_app/features/songs/presentation/views/widgets/song_item.dart';

void main() {
  testWidgets('SongItemWidget renders correctly', (WidgetTester tester) async {
    final song = SongEntity(
      id: '1',
      title: 'Test Song',
      artist: 'Test Artist',
      imgURL: 'https://example.com/image.jpg',
      previewURL: 'https://example.com/preview.mp3',
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SongItemWidget(
              song: song,
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Test Song'), findsOneWidget);
    expect(find.text('Test Artist'), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets('SongItemWidget play button toggles correctly',
      (WidgetTester tester) async {
    final song = SongEntity(
      id: '1',
      title: 'Test Song',
      artist: 'Test Artist',
      imgURL: 'https://example.com/image.jpg',
      previewURL: 'https://example.com/preview.mp3',
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SongItemWidget(
              song: song,
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    final playButton = find.byIcon(Icons.play_arrow);
    expect(playButton, findsOneWidget);
    await tester.tap(playButton);
    await tester.pump();
    expect(find.byIcon(Icons.pause), findsOneWidget);
  });
}
