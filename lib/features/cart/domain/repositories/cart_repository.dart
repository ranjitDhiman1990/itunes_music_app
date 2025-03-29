import 'package:itunes_music_app/features/cart/domain/entities/cart_entity.dart';

abstract class CartRepository {
  Future<List<CartEntity>> getCartItems();
  Future<void> addToCart(String songId);
  Future<void> removeFromCart(String songId);
  Future<void> updateCartItemQuantity(String songId, int quantity);
  Future<void> clearCart();
}
