import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/app/routes.dart';
import 'package:itunes_music_app/features/cart/presentation/view_models/cart_view_model.dart';
import 'package:itunes_music_app/features/songs/presentation/view_models/song_view_model.dart';
import 'package:itunes_music_app/features/songs/presentation/views/widgets/song_item.dart';

class SongListScreen extends ConsumerWidget {
  const SongListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songState = ref.watch(songViewModel);
    final cartState = ref.watch(cartViewModel);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Songs List'),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.cart);
                },
                icon: const Icon(Icons.shopping_cart),
              ),
              if (cartState.totalItems > 0) ...[
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 10,
                    child: Text(
                      '${cartState.totalItems}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          )
        ],
      ),
      body: songState.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : songState.error != null
              ? Center(
                  child: Text('Error: ${songState.error ?? ''}'),
                )
              : ListView.builder(
                  itemCount: songState.songs.length,
                  itemBuilder: (context, index) {
                    final song = songState.songs[index];
                    return SongItemWidget(
                      song: song,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.songDetails,
                          arguments: song.id,
                        );
                      },
                    );
                  },
                ),
    );
  }
}
