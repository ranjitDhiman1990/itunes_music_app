import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/features/cart/domain/entities/cart_entity.dart';
import 'package:itunes_music_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cart_repository_test.mocks.dart';

@GenerateMocks([CartRepository])
void main() {
  late MockCartRepository mockCartRepository;
  const testSongId = 'song_123';
  const testQuantity = 2;
  final testCartItems = [
    CartEntity(songId: 'song_1', quantity: 1),
    CartEntity(songId: 'song_2', quantity: 2),
  ];

  setUp(() {
    mockCartRepository = MockCartRepository();
  });

  group('CartRepository', () {
    test('getCartItems() should return list of CartEntity', () async {
      // Arrange
      when(mockCartRepository.getCartItems())
          .thenAnswer((_) async => testCartItems);

      // Act
      final result = await mockCartRepository.getCartItems();

      // Assert
      expect(result, isA<List<CartEntity>>());
      expect(result.length, testCartItems.length);
      verify(mockCartRepository.getCartItems()).called(1);
    });

    test('addToCart() should complete without error when successful', () async {
      // Arrange
      when(mockCartRepository.addToCart(testSongId)).thenAnswer((_) async {});

      // Act & Assert
      expect(() async => await mockCartRepository.addToCart(testSongId),
          returnsNormally);
      verify(mockCartRepository.addToCart(testSongId)).called(1);
    });

    test('removeFromCart() should complete without error when successful',
        () async {
      // Arrange
      when(mockCartRepository.removeFromCart(testSongId))
          .thenAnswer((_) async {});

      // Act & Assert
      expect(() async => await mockCartRepository.removeFromCart(testSongId),
          returnsNormally);
      verify(mockCartRepository.removeFromCart(testSongId)).called(1);
    });

    test(
        'updateCartItemQuantity() should complete without error when successful',
        () async {
      // Arrange
      when(mockCartRepository.updateCartItemQuantity(testSongId, testQuantity))
          .thenAnswer((_) async {});

      // Act & Assert
      expect(
          () async => await mockCartRepository.updateCartItemQuantity(
              testSongId, testQuantity),
          returnsNormally);
      verify(mockCartRepository.updateCartItemQuantity(
              testSongId, testQuantity))
          .called(1);
    });

    test('clearCart() should complete without error when successful', () async {
      // Arrange
      when(mockCartRepository.clearCart()).thenAnswer((_) async {});

      // Act & Assert
      expect(() async => await mockCartRepository.clearCart(), returnsNormally);
      verify(mockCartRepository.clearCart()).called(1);
    });

    test('getCartItems() should throw exception when failed', () async {
      // Arrange
      when(mockCartRepository.getCartItems())
          .thenThrow(Exception('Failed to load cart'));

      // Act & Assert
      expect(() => mockCartRepository.getCartItems(), throwsException);
    });

    test('addToCart() should throw exception when failed', () async {
      // Arrange
      when(mockCartRepository.addToCart(testSongId))
          .thenThrow(Exception('Failed to add item'));

      // Act & Assert
      expect(() => mockCartRepository.addToCart(testSongId), throwsException);
    });
  });
}
