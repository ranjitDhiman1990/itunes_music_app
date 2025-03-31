import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/features/cart/data/datasources/local_data_source.dart';
import 'package:itunes_music_app/features/cart/data/models/cart_model.dart';
import 'package:itunes_music_app/features/cart/data/repositories/cart_repository.dart';
import 'package:itunes_music_app/features/cart/domain/entities/cart_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDataSource extends Mock implements LocalDataSource {}

class MockCartModel extends Mock implements CartModel {
  CartEntity toEntity() => CartEntity(songId: '123', quantity: 1);
}

void main() {
  late CartRepositoryImpl cartRepositoryImpl;
  late MockLocalDataSource mockLocalDataSource;
  const testSongId = '123';

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    cartRepositoryImpl =
        CartRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  test('should call localDataSource.addToCart with correct songId', () async {
    when(() => mockLocalDataSource.addToCart(testSongId))
        .thenAnswer((_) async => {});
    await cartRepositoryImpl.addToCart(testSongId);
    verify(() => mockLocalDataSource.addToCart(testSongId)).called(1);
  });

  test('should call localDataSource.removeFromCart with correct songId',
      () async {
    when(() => mockLocalDataSource.removeFromCart(any()))
        .thenAnswer((_) async => {});
    await cartRepositoryImpl.removeFromCart(testSongId);
    verify(() => mockLocalDataSource.removeFromCart(testSongId)).called(1);
  });

  test('should call localDataSource.clearCart', () async {
    when(() => mockLocalDataSource.clearCart()).thenAnswer((_) async => {});
    await cartRepositoryImpl.clearCart();
    verify(() => mockLocalDataSource.clearCart()).called(1);
  });

  test('should return list of CartEntity from localDataSource', () async {
    final mockItems = [
      CartModel(songId: '123', quantity: 1),
      CartModel(songId: '234', quantity: 5),
    ];
    when(() => mockLocalDataSource.getCartItems())
        .thenAnswer((_) async => mockItems);

    final result = await cartRepositoryImpl.getCartItems();

    expect(result, isA<List<CartEntity>>());
    expect(result.length, mockItems.length);
    verify(() => mockLocalDataSource.getCartItems()).called(1);
  });

  test(
      'should call localDataSource.updateCartItemQuantity with correct parameters',
      () async {
    when(() => mockLocalDataSource.updateCartItemQuantity(any(), any()))
        .thenAnswer((_) async => {});
    await cartRepositoryImpl.updateCartItemQuantity(testSongId, 3);

    verify(() => mockLocalDataSource.updateCartItemQuantity(testSongId, 3))
        .called(1);
  });
}
