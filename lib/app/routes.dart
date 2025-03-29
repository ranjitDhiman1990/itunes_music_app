import 'package:flutter/material.dart';
import 'package:itunes_music_app/features/cart/presentation/views/cart_screen.dart';
import 'package:itunes_music_app/features/songs/presentation/views/song_details_screen.dart';
import 'package:itunes_music_app/features/songs/presentation/views/song_list_screen.dart';

class AppRoutes {
  static const String songList = '/';
  static const String songDetails = '/song-details';
  static const String cart = '/cart';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case songList:
        return MaterialPageRoute(builder: (_) => const SongListScreen());
      case songDetails:
        return MaterialPageRoute(builder: (_) => const SongDetailsScreen());
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
