import 'package:itunes_music_app/core/database/app_database.dart';
import 'package:itunes_music_app/features/cart/data/models/cart_model.dart';

abstract class LocalDataSource {
  Future<List<CartModel>> getCartItems();
  Future<void> addToCart(String songId);
  Future<void> removeFromCart(String songId);
  Future<void> updateCartItemQuantity(String songId, int quantity);
  Future<void> clearCart();
}

class LocalDataSourceImpl implements LocalDataSource {
  final AppDatabase appDatabase;

  LocalDataSourceImpl({required this.appDatabase});

  @override
  Future<void> addToCart(String songId) async {
    final cartItem = CartModel(songId: songId, quantity: 1);
    final database = await appDatabase.database;
    await database.insert('cart', cartItem.toJson());
  }

  @override
  Future<void> clearCart() async {
    final database = await appDatabase.database;
    database.delete('cart');
  }

  @override
  Future<List<CartModel>> getCartItems() async {
    final database = await appDatabase.database;
    final List<Map<String, dynamic>> jsonArray = await database.query('cart');
    return List.generate(jsonArray.length, (index) {
      return CartModel(
        songId: jsonArray[index]['songId'],
        quantity: jsonArray[index]['quantity'],
      );
    });
  }

  @override
  Future<void> removeFromCart(String songId) async {
    final database = await appDatabase.database;
    await database.delete(
      'cart',
      where: 'songId = ?',
      whereArgs: [songId],
    );
  }

  @override
  Future<void> updateCartItemQuantity(String songId, int quantity) async {
    final database = await appDatabase.database;
    await database.update(
      'cart',
      {'quantity': quantity},
      where: 'songId = ?',
      whereArgs: [songId],
    );
  }
}
