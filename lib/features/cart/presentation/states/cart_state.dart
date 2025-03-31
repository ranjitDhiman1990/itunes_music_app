import 'package:collection/collection.dart';
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartState &&
          runtimeType == other.runtimeType &&
          // Compare list contents (order matters)
          const ListEquality().equals(cartItems, other.cartItems) &&
          isLoading == other.isLoading;

  @override
  int get hashCode => const ListEquality().hash(cartItems) ^ isLoading.hashCode;
}
