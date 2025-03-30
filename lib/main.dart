import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/app/app.dart';
import 'package:itunes_music_app/core/providers/providers.dart';
import 'package:itunes_music_app/core/services/audio_player_service.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        audioPlayerServiceProvider.overrideWith(
          (ref) {
            final service = AudioPlayerService();
            ref.onDispose(() => service.dispose());
            return service;
          },
        ),
      ],
      child: const App(),
    ),
  );
}
