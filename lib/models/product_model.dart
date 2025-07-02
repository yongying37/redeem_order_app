class Product {
  final String productId;
  final String productName;
  final double productPrice;
  final String productUrl;

  Product({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? 'Unnamed',
      productPrice: (json['product_price'] ?? 0).toDouble(),
      productUrl: json['product_url'] ?? '',
    );
  }

}

