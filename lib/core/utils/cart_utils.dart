import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/features/cart/presentation/view_models/cart_view_model.dart';
import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';

class CartUtils {
  static Future<void> showCartQuantityDialog({
    required BuildContext context,
    required WidgetRef ref,
    required SongEntity song,
  }) async {
    final cartState = ref.read(cartViewModel);
    final item =
        cartState.cartItems.firstWhere((item) => item.songId == song.id);

    final action = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Item in Cart'),
        content:
            Text('"${song.title}" already has ${item.quantity} in cart.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, 'cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
            onPressed: () => Navigator.pop(context, 'remove'),
          ),
          TextButton(
            child: const Text('Add More'),
            onPressed: () => Navigator.pop(context, 'add'),
          ),
        ],
      ),
    );

    if (action == 'remove') {
      await ref.read(cartViewModel.notifier).removeFromCart(song.id);
      if (context.mounted) {
        showRemovalConfirmation(context, song);
      }
    } else if (action == 'add') {
      await ref
          .read(cartViewModel.notifier)
          .updateCartItemQuantity(song.id, item.quantity + 1);
      if (context.mounted) {
        showUpdateConfirmation(context, item.quantity + 1);
      }
    }
  }

  static void showAddConfirmation(BuildContext context, SongEntity song) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${song.title}" added to cart'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showUpdateConfirmation(BuildContext context, int newQuantity) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Updated quantity to $newQuantity'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showRemovalConfirmation(BuildContext context, SongEntity song) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${song.title}" removed from cart'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
