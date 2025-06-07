class CartItem {
  final String name;
  final String price;
  final String image;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });
}

class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(CartItem item) {
    final existing = _items.indexWhere((e) => e.name == item.name);
    if (existing != -1) {
      _items[existing].quantity += 1;
    } else {
      _items.add(item);
    }
  }

  void clearCart() => _items.clear();
}
