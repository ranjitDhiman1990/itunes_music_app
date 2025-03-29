import 'package:itunes_music_app/features/cart/data/models/cart_model.dart';

class CartEntity {
  final String songId;
  final int quantity;

  CartEntity({
    required this.songId,
    required this.quantity,
  });
}

extension CartItemModelExtensions on CartModel {
  CartEntity toEntity() {
    return CartEntity(
      songId: songId,
      quantity: quantity,
    );
  }
}
