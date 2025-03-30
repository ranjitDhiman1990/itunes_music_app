import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/core/database/app_database.dart';
import 'package:itunes_music_app/features/cart/data/datasources/local_data_source.dart';
import 'package:itunes_music_app/features/cart/data/models/cart_model.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

class MockDatabase extends Mock implements Database {}

void main() {
  late LocalDataSourceImpl localDataSource;
  late MockAppDatabase mockAppDatabase;
  late MockDatabase mockDatabase;

  setUp(() {
    mockAppDatabase = MockAppDatabase();
    mockDatabase = MockDatabase();
    localDataSource = LocalDataSourceImpl(appDatabase: mockAppDatabase);

    // Stub the database getter to return our mock database
    when(mockAppDatabase.database).thenAnswer((_) async => mockDatabase);
  });

  group('LocalDataSourceImpl', () {
    const testSongId = '123';
    const testSongId2 = '456';
    final testCartItem = CartModel(songId: testSongId, quantity: 1);
    final testCartItem2 = CartModel(songId: testSongId2, quantity: 2);
    final testCartItems = [testCartItem, testCartItem2];

    test('getCartItems returns list of CartModel when database has items',
        () async {
      // Arrange
      when(mockDatabase.query('cart')).thenAnswer((_) async => [
            {'songId': testSongId, 'quantity': 1},
            {'songId': testSongId2, 'quantity': 2},
          ]);

      // Act
      final result = await localDataSource.getCartItems();

      // Assert
      expect(result, equals(testCartItems));
      verify(mockDatabase.query('cart'));
    });

    test('getCartItems returns empty list when database is empty', () async {
      // Arrange
      when(mockDatabase.query('cart')).thenAnswer((_) async => []);

      // Act
      final result = await localDataSource.getCartItems();

      // Assert
      expect(result, isEmpty);
      verify(mockDatabase.query('cart'));
    });

    test('addToCart inserts item into database', () async {
      // Arrange
      when(mockDatabase.insert(
        'cart',
        {
          'songId': testSongId,
          'quantity': 1,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      )).thenAnswer((_) async => 1);

      // Act
      await localDataSource.addToCart(testSongId);

      // Assert
      verify(mockDatabase.insert(
        'cart',
        {
          'songId': testSongId,
          'quantity': 1,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      ));
    });

    test('removeFromCart deletes item from database', () async {
      // Arrange
      when(mockDatabase.delete('cart',
          where: 'songId = ?',
          whereArgs: [testSongId])).thenAnswer((_) async => 1);

      // Act
      await localDataSource.removeFromCart(testSongId);

      // Assert
      verify(mockDatabase.delete(
        'cart',
        where: 'songId = ?',
        whereArgs: [testSongId],
      ));
    });

    test('updateCartItemQuantity updates quantity in database', () async {
      // Arrange
      const newQuantity = 3;
      when(mockDatabase.update(
        'cart',
        {'quantity': newQuantity},
        where: 'songId = ?',
        whereArgs: [testSongId],
      )).thenAnswer((_) async => 1);

      // Act
      await localDataSource.updateCartItemQuantity(testSongId, newQuantity);

      // Assert
      verify(mockDatabase.update(
        'cart',
        {'quantity': newQuantity},
        where: 'songId = ?',
        whereArgs: [testSongId],
      ));
    });

    test('clearCart deletes all items from database', () async {
      // Arrange
      when(mockDatabase.delete('cart')).thenAnswer((_) async => 2);

      // Act
      await localDataSource.clearCart();

      // Assert
      verify(mockDatabase.delete('cart'));
    });

    test('throws exception when database operations fail', () async {
      // Arrange
      when(mockDatabase.query('cart')).thenThrow(Exception('Database error'));

      // Act & Assert
      expect(() => localDataSource.getCartItems(), throwsException);
    });
  });
}
