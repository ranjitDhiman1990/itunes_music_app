import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/core/providers/providers.dart';
import 'package:itunes_music_app/core/utils/cart_utils.dart';
import 'package:itunes_music_app/core/utils/common_imageview_widget.dart';
import 'package:itunes_music_app/features/cart/presentation/view_models/cart_view_model.dart';
import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';

class SongItemWidget extends ConsumerStatefulWidget {
  final SongEntity song;
  final VoidCallback onTap;

  const SongItemWidget({
    super.key,
    required this.song,
    required this.onTap,
  });

  @override
  ConsumerState<SongItemWidget> createState() => _SongItemWidgetState();
}

class _SongItemWidgetState extends ConsumerState<SongItemWidget> {
  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartViewModel);
    final playerState = ref.watch(playerProvider);
    final isCurrentSong = playerState.currentSongId == widget.song.id;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: CommonImageViewWidget(
            imageUrl: widget.song.imgURL ?? '',
            height: 50,
            width: 50,
          ),
        ),
        title: Text(widget.song.title ?? ''),
        subtitle: Text(widget.song.artist ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () async {
                if (widget.song.previewURL == null) return;
                final audioController = ref.read(audioControllerProvider);
                if (isCurrentSong && playerState.isPlaying) {
                  audioController.pause();
                } else {
                  audioController.play(widget.song.id, widget.song.previewURL!,
                      widget.song.title ?? '');
                }
              },
              icon: Icon((isCurrentSong && playerState.isPlaying)
                  ? Icons.pause
                  : Icons.play_arrow),
            ),
            IconButton(
              onPressed: () async {
                if (cartState.isInCart(widget.song.id)) {
                  await CartUtils.showCartQuantityDialog(
                      context: context, ref: ref, song: widget.song);
                } else {
                  ref.read(cartViewModel.notifier).addToCart(widget.song.id);
                  if (context.mounted) {
                    CartUtils.showAddConfirmation(context, widget.song);
                  }
                }
              },
              icon: Icon(cartState.isInCart(widget.song.id)
                  ? Icons.remove_shopping_cart
                  : Icons.add_shopping_cart),
            )
          ],
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
