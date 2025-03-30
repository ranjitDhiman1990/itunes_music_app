import 'package:itunes_music_app/features/cart/domain/entities/cart_entity.dart';

class CartState {
  final List<CartEntity> cartItems;
  final bool isLoading;

  CartState({
    this.cartItems = const [],
    this.isLoading = false,
  });

  CartState copyWith({
    List<CartEntity>? cartItems,
    bool? isLoading,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);

  bool isInCart(String songId) {
    return cartItems.any((item) => item.songId == songId);
  }
}
