class CartModel {
  final String songId;
  final int quantity;

  CartModel({
    required this.songId,
    required this.quantity,
  }) {
    if (quantity < 0) {
      throw ArgumentError('Quantity cannot be negative.');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'songId': songId,
      'quantity': quantity,
    };
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      songId: json['songId'],
      quantity: json['quantity'],
    );
  }
}
