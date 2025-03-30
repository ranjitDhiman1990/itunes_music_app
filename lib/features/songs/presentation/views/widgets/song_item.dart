import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/core/utils/cart_utils.dart';
import 'package:itunes_music_app/core/utils/common_imageview_widget.dart';
import 'package:itunes_music_app/features/cart/presentation/view_models/cart_view_model.dart';
import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';

class SongItemWidget extends ConsumerWidget {
  final SongEntity song;
  final VoidCallback onTap;

  const SongItemWidget({
    super.key,
    required this.song,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartViewModel);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: CommonImageViewWidget(
            imageUrl: song.imgURL ?? '',
            height: 50,
            width: 50,
          ),
        ),
        title: Text(song.title ?? ''),
        subtitle: Text(song.artist ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                // TODO: Implement Play audion funtionality
              },
              icon: const Icon(Icons.play_arrow),
            ),
            IconButton(
              onPressed: () async {
                if (cartState.isInCart(song.id)) {
                  await CartUtils.showCartQuantityDialog(
                      context: context, ref: ref, song: song);
                } else {
                  ref.read(cartViewModel.notifier).addToCart(song.id);
                  if (context.mounted) {
                    CartUtils.showAddConfirmation(context, song);
                  }
                }
              },
              icon: Icon(cartState.isInCart(song.id)
                  ? Icons.remove_shopping_cart
                  : Icons.add_shopping_cart),
            )
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
