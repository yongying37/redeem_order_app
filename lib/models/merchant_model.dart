class Merchant {
  final String id;
  final String name;
  final String unitNo;
  final String imageUrl;
  final bool supportsDineIn;
  final bool supportsTakeaway;

  Merchant({
    required this.id,
    required this.name,
    required this.unitNo,
    required this.imageUrl,
    required this.supportsDineIn,
    required this.supportsTakeaway,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {

    return Merchant(
      id: json['merchant_id'] ?? '',
      name: json['merchant_name'] ?? '',
      unitNo: json['merchant_unit_no'] ?? '',
      imageUrl: json['merchant_img_url'] ?? '',
      supportsDineIn: true,
      supportsTakeaway: true,
    );
  }
}
