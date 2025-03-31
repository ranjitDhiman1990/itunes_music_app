import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/features/songs/presentation/view_models/song_view_model.dart';
import 'package:itunes_music_app/features/songs/presentation/views/song_details_screen.dart';

import 'song_list_screen_test.dart';

void main() {
  testWidgets('SongDetailsScreen displays song details and buttons',
      (WidgetTester tester) async {
    // Mock Data
    const songId = '123';

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          songViewModel.overrideWith((ref) => MockSongViewModel()),
        ],
        child: const MaterialApp(
            home: SongDetailsScreen(
          songId: songId,
        )),
      ),
    );
    
    expect(find.text('Test Song'), findsOneWidget);
  });
}
