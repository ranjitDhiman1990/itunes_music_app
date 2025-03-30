import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/app/routes.dart';
import 'package:itunes_music_app/core/providers/providers.dart';
import 'package:itunes_music_app/core/services/player_state.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
