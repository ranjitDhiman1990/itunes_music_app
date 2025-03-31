import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/features/cart/domain/entities/cart_entity.dart';
import 'package:itunes_music_app/features/cart/presentation/states/cart_state.dart';

void main() {
  group('CartState', () {
    // Test data
    final sampleItem1 = CartEntity(songId: 'song1', quantity: 2);
    final sampleItem2 = CartEntity(songId: 'song2', quantity: 3);
    final sampleItems = [sampleItem1, sampleItem2];

    test('initial state has empty cart and not loading', () {
      // Arrange & Act
      final state = CartState();

      // Assert
      expect(state.cartItems, isEmpty);
      expect(state.isLoading, isFalse);
    });

    test('copyWith updates only specified fields', () {
      // Arrange
      final initialState = CartState(cartItems: sampleItems, isLoading: true);

      // Act - Update only cartItems
      final updatedCartState = initialState.copyWith(
        cartItems: [sampleItem1],
      );

      // Assert
      expect(updatedCartState.cartItems, hasLength(1));
      expect(updatedCartState.cartItems.first, sampleItem1);
      expect(updatedCartState.isLoading, isTrue); // unchanged

      // Act - Update only isLoading
      final updatedLoadingState = initialState.copyWith(
        isLoading: false,
      );

      // Assert
      expect(updatedLoadingState.cartItems, sampleItems); // unchanged
      expect(updatedLoadingState.isLoading, isFalse);
    });

    test('copyWith maintains state when no parameters are provided', () {
      // Arrange
      final initialState = CartState(cartItems: sampleItems, isLoading: true);

      // Act
      final unchangedState = initialState.copyWith();

      // Assert
      expect(unchangedState.cartItems, sampleItems);
      expect(unchangedState.isLoading, isTrue);
    });

    test('totalItems calculates sum of all item quantities', () {
      // Arrange
      final state = CartState(cartItems: sampleItems);

      // Act & Assert
      expect(state.totalItems, 5); // 2 + 3

      // Test with empty cart
      expect(CartState().totalItems, 0);
    });

    test('isInCart correctly identifies items in cart', () {
      // Arrange
      final state = CartState(cartItems: sampleItems);

      // Act & Assert
      expect(state.isInCart('song1'), isTrue);
      expect(state.isInCart('song2'), isTrue);
      expect(state.isInCart('nonexistent'), isFalse);

      // Test with empty cart
      expect(CartState().isInCart('any'), isFalse);
    });

    test('equality comparison works correctly', () {
      // Arrange
      final state1 = CartState(cartItems: sampleItems, isLoading: true);
      final state2 = CartState(cartItems: sampleItems, isLoading: true);
      final state3 = CartState(cartItems: [sampleItem1], isLoading: false);

      // Act & Assert
      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });

    test('handles empty cart edge cases', () {
      // Arrange
      final emptyState = CartState();

      // Act & Assert
      expect(emptyState.totalItems, 0);
      expect(emptyState.isInCart('any'), isFalse);
      expect(emptyState.copyWith().cartItems, isEmpty);
    });
  });
}
