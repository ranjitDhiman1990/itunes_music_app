import 'package:itunes_music_app/features/cart/data/datasources/local_data_source.dart';
import 'package:itunes_music_app/features/cart/domain/entities/cart_entity.dart';
import 'package:itunes_music_app/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final LocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addToCart(String songId) async {
    await localDataSource.addToCart(songId);
  }

  @override
  Future<void> clearCart() async {
    await localDataSource.clearCart();
  }

  @override
  Future<List<CartEntity>> getCartItems() async {
    final cartItems = await localDataSource.getCartItems();
    return cartItems.map((cartItem) => cartItem.toEntity()).toList();
  }

  @override
  Future<void> removeFromCart(String songId) async {
    await localDataSource.removeFromCart(songId);
  }

  @override
  Future<void> updateCartItemQuantity(String songId, int quantity) async {
    await localDataSource.updateCartItemQuantity(songId, quantity);
  }
}
