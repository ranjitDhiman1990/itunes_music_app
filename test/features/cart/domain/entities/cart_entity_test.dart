import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/features/cart/data/models/cart_model.dart';
import 'package:itunes_music_app/features/cart/domain/entities/cart_entity.dart';

void main() {
  group('CartItemModelExtensions', () {
    test('toEntity() should convert CartModel to CartEntity with same values', () {
      // Arrange
      const testSongId = 'song123';
      const testQuantity = 2;
      final cartModel = CartModel(
        songId: testSongId,
        quantity: testQuantity,
      );

      // Act
      final result = cartModel.toEntity();

      // Assert
      expect(result, isA<CartEntity>());
      expect(result.songId, testSongId);
      expect(result.quantity, testQuantity);
    });

    test('toEntity() should handle zero quantity', () {
      // Arrange
      const testSongId = 'song456';
      const testQuantity = 0;
      final cartModel = CartModel(
        songId: testSongId,
        quantity: testQuantity,
      );

      // Act
      final result = cartModel.toEntity();

      // Assert
      expect(result.quantity, testQuantity);
    });

    test('toEntity() should handle empty songId', () {
      // Arrange
      const testSongId = '';
      const testQuantity = 1;
      final cartModel = CartModel(
        songId: testSongId,
        quantity: testQuantity,
      );

      // Act
      final result = cartModel.toEntity();

      // Assert
      expect(result.songId, testSongId);
    });
  });
}