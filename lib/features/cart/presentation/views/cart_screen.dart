import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/features/cart/presentation/view_models/cart_view_model.dart';
import 'package:itunes_music_app/features/songs/presentation/view_models/song_view_model.dart';

import 'widgets/cart_item.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartViewModel);
    final songState = ref.watch(songViewModel);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Details'),
      ),
      body: cartState.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : cartState.cartItems.isEmpty
              ? const Center(
                  child: Text('No items added in cart!!!'),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartState.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartState.cartItems[index];
                          final song = songState.songsMap[item.songId];
                          if (song == null) return const SizedBox.shrink();
                          return CartItem(
                            song: song,
                            quantity: item.quantity,
                            onIncrement: () {
                              ref
                                  .read(cartViewModel.notifier)
                                  .updateCartItemQuantity(
                                      item.songId, item.quantity + 1);
                            },
                            onDecrement: () {
                              ref
                                  .read(cartViewModel.notifier)
                                  .updateCartItemQuantity(
                                      item.songId, item.quantity - 1);
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: cartState.cartItems.isEmpty
                            ? null
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Checkout'),
                                    content: Text(
                                        'You have ${cartState.totalItems} items in your cart.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('CANCEL'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          ref
                                              .read(cartViewModel.notifier)
                                              .clearCart();
                                          Navigator.popUntil(context,
                                              (route) => route.isFirst);
                                        },
                                        child: const Text('DONE'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                        child: const Text('Checkout'),
                      ),
                    ),
                  ],
                ),
    );
  }
}
