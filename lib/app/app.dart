import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/app/routes.dart';
import 'package:itunes_music_app/core/providers/providers.dart';
import 'package:itunes_music_app/core/services/audio_player/audio_player_controller.dart';
import 'package:itunes_music_app/core/services/audio_player/player_state.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    final audioController = ref.read(audioControllerProvider);
    setGlobalAudioController(audioController);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<PlayerState>(playerProvider, (_, state) {
      if (state.currentSongId == null) {
        ref.read(audioControllerProvider).stop();
      }
    });

    return MaterialApp(
      title: "iTunes Music App",
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.songList,
      debugShowCheckedModeBanner: false,
    );
  }
}
