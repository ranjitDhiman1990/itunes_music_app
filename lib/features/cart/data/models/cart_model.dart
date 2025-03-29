class CartModel {
  final String songId;
  final int quantity;

  CartModel({
    required this.songId,
    required this.quantity,
  });

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
