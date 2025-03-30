import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/core/providers/providers.dart';
import 'package:itunes_music_app/core/utils/cart_utils.dart';
import 'package:itunes_music_app/core/utils/common_imageview_widget.dart';
import 'package:itunes_music_app/features/cart/presentation/view_models/cart_view_model.dart';
import 'package:itunes_music_app/features/songs/presentation/view_models/song_view_model.dart';

class SongDetailsScreen extends ConsumerStatefulWidget {
  final String songId;
  const SongDetailsScreen({
    super.key,
    required this.songId,
  });

  @override
  ConsumerState<SongDetailsScreen> createState() => _SongDetailsScreenState();
}

class _SongDetailsScreenState extends ConsumerState<SongDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);
    final isPlaying =
        playerState.currentSongId == widget.songId && playerState.isPlaying;
    final cartState = ref.watch(cartViewModel);
    final songState = ref.watch(songViewModel);
    final song =
        songState.songs.firstWhere((element) => element.id == widget.songId);

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
                  if (cartState.isInCart(widget.songId)) {
                    await CartUtils.showCartQuantityDialog(
                        context: context, ref: ref, song: song);
                  } else {
                    await ref
                        .read(cartViewModel.notifier)
                        .addToCart(widget.songId);
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
                ElevatedButton.icon(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(isPlaying ? 'Pause Song' : 'Play Song'),
                  onPressed: () async {
                    if (song.previewURL == null) return;
                    final audioController = ref.read(audioControllerProvider);
                    isPlaying
                        ? audioController.pause()
                        : audioController.play(widget.songId, song.previewURL!);
                  },
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
