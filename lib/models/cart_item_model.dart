class AddOnItem {
  final String id;
  final int quantity;

  AddOnItem({
    required this.id,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    'product_id': id,
    'add_on_qty': quantity,
  };
}

class CartItem {
  final String id;
  final String name;
  final double price;
  final String imgUrl;
  int quantity;

  final String? productId;
  final String? merchantId;
  final List<AddOnItem> addOns;
  final String? preference;
  final String? remarks;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imgUrl,
    this.quantity = 1,
    this.productId,
    this.merchantId,
    this.addOns = const [],
    this.preference,
    this.remarks,
  });

  CartItem copyWith ({
    String? id,
    String? name,
    double? price,
    String? imgUrl,
    int? quantity,
    String? productId,
    String? merchantId,
    List<AddOnItem>? addOns,
    String? preference,
    String? remarks,
  }) {
    return CartItem(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        imgUrl: imgUrl ?? this.imgUrl,
        quantity: quantity ?? this.quantity,
        productId: productId ?? this.productId,
        merchantId: merchantId ?? this.merchantId,
        addOns: addOns ?? this.addOns,
        preference: preference ?? this.preference,
        remarks: remarks ?? this.remarks,
    );
  }

  Map<String, dynamic> toOrderJson() {
    return {
      'product_id': productId ?? id,
      'order_qty': quantity.toString(),
      'txn_order_consumer_add_ons': addOns.map((a) => a.toJson()).toList(),
      'order_pref': preference ?? '',
      'order_remarks': remarks ?? '',
    };
  }
}