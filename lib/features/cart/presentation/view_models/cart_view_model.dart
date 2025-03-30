import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/core/providers/providers.dart';
import 'package:itunes_music_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:itunes_music_app/features/cart/presentation/states/cart_state.dart';

final cartViewModel = StateNotifierProvider<CartViewModel, CartState>((ref) {
  final repository = ref.read(cartRepositoryProvider);
  return CartViewModel(repository);
});

class CartViewModel extends StateNotifier<CartState> {
  final CartRepository _repository;

  CartViewModel(this._repository) : super(CartState()) {
    getCartItems();
  }

  Future<void> getCartItems() async {
    state = state.copyWith(isLoading: true);
    try {
      final cartItems = await _repository.getCartItems();
      state = state.copyWith(cartItems: cartItems, isLoading: false);
    } catch (err) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> addToCart(String songId) async {
    await _repository.addToCart(songId);
    await getCartItems();
  }

  Future<void> removeFromCart(String songId) async {
    await _repository.removeFromCart(songId);
    await getCartItems();
  }

  Future<void> updateCartItemQuantity(String songId, int quantity) async {
    if (quantity <= 0) {
      removeFromCart(songId);
    } else {
      await _repository.updateCartItemQuantity(songId, quantity);
      await getCartItems();
    }
  }

  Future<void> clearCart() async {
    await _repository.clearCart();
    await getCartItems();
  }
}
