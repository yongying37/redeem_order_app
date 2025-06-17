class CartItem {
  final String id;
  final String name;
  final double price;
  final String imgUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imgUrl,
    this.quantity = 1
  });

  CartItem copyWith ({int? quantity}) {
    return CartItem(
        id: id,
        name: name,
        price: price,
        imgUrl: imgUrl,
        quantity: quantity ?? this.quantity,
    );
  }
}