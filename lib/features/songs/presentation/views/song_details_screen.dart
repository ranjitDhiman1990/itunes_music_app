import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/core/utils/cart_utils.dart';
import 'package:itunes_music_app/core/utils/common_imageview_widget.dart';
import 'package:itunes_music_app/features/cart/presentation/view_models/cart_view_model.dart';
import 'package:itunes_music_app/features/songs/presentation/view_models/song_view_model.dart';

class SongDetailsScreen extends ConsumerWidget {
  final String songId;
  const SongDetailsScreen({
    super.key,
    required this.songId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartViewModel);
    final songState = ref.watch(songViewModel);
    final song = songState.songs.firstWhere((element) => element.id == songId);

    return Scaffold(
      appBar: AppBar(
        title: Text(song.title ?? ''),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CommonImageViewWidget(
                  imageUrl: song.imgURL ?? '',
                  height: 200,
                  width: 200,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                song.title ?? '',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center, // Center text
              ),
              Text(
                song.artist ?? '',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Album: ${song.album}',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (cartState.isInCart(songId)) {
                    await CartUtils.showCartQuantityDialog(
                        context: context, ref: ref, song: song);
                  } else {
                    await ref.read(cartViewModel.notifier).addToCart(songId);
                    if (context.mounted) {
                      CartUtils.showAddConfirmation(context, song);
                    }
                  }
                },
                child: Text(cartState.isInCart(song.id)
                    ? 'Remove from Cart'
                    : 'Add to Cart'),
              ),
              if (song.previewURL != null) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement play functionality
                  },
                  child: const Text('Play Preview'),
                ),
              ],
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
