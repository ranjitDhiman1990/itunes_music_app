import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/features/cart/data/models/cart_model.dart';

void main() {
  test('Should create a CartModel with valid songId and quantity', () {
    const songId = 'song123';
    const quantity = 2;

    final cart = CartModel(songId: songId, quantity: quantity);

    expect(cart.songId, songId);
    expect(cart.quantity, quantity);
  });

  test('Should convert CartModel to a correct JSON map', () {
    const songId = 'song456';
    const quantity = 1;

    final cart = CartModel(songId: songId, quantity: quantity);
    final json = cart.toJson();

    expect(json, isA<Map<String, dynamic>>());
    expect(json['songId'], songId);
    expect(json['quantity'], quantity);
  });

  test('Should create CartModel from a valid JSON map', () {
    final json = {
      'songId': 'song789',
      'quantity': 3,
    };

    final cart = CartModel.fromJson(json);

    expect(cart.songId, json['songId']);
    expect(cart.quantity, json['quantity']);
  });

  test('Should throw an error if JSON is missing required fields', () {
    final invalidJson = {
      'songId': 'song999', // Missing 'quantity'
    };

    expect(() => CartModel.fromJson(invalidJson), throwsA(isA<Error>()));
  });

  test('Should allow zero quantity (edge case)', () {
    const songId = 'song000';
    const quantity = 0;

    final cart = CartModel(songId: songId, quantity: quantity);

    expect(cart.quantity, 0);
  });

  test('Should throw an error if quantity is negative', () {
    const songId = 'songNeg';
    const quantity = -1;

    expect(() => CartModel(songId: songId, quantity: quantity),
        throwsA(isA<Error>()));
  });

  test('Should handle empty songId (edge case)', () {
    const songId = '';
    const quantity = 1;

    final cart = CartModel(songId: songId, quantity: quantity);

    expect(cart.songId, '');
  });
}
