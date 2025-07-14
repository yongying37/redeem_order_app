class OrderHistory {
  final String productName;
  final double productPrice;
  final String productImage;
  final String orderType;
  final DateTime orderDatetime;
  final String productId;
  final String merchantId;

  OrderHistory({
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.orderType,
    required this.orderDatetime,
    required this.productId,
    required this.merchantId,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    try {
      return OrderHistory(
        productName: json['product_name'] ?? json['productName'] ?? 'Unknown',
        productPrice: (json['product_price'] ?? json['productPrice'] ?? 0).toDouble(),
        productImage: json['product_url'] ?? json['productImage'] ?? '',
        orderType: json['order_type'] ?? json['orderType'] ?? 'Unknown',
        orderDatetime: DateTime.parse(json['order_datetime'] ?? json['orderDatetime']),
        productId: json['product_id'] ?? json['productId'] ?? 'Unknown',
        merchantId: json['merchant_id'] ?? json['merchantId'] ?? 'Unknown',
      );
    } catch (e) {
      print('Failed to parse order: $e');
      print('JSON: $json');
      rethrow;
    }
  }


}
