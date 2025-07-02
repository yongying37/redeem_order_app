import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:redeem_order_app/models/product_model.dart';

class ProductService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  static Future<List<Product>> fetchProducts({String? merchantId}) async {
    final uri = merchantId != null
        ? Uri.parse('$baseUrl/merchants/products?merchant_id=$merchantId')
        : Uri.parse('$baseUrl/merchants/products');

    try {
      final response = await http.get(uri);

      print('Status Code: ${response.statusCode}');
      print('Raw Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData == null || jsonData is! List) {
          print('Warning: API did not return a list as expected.');
          return [];
        }

        return jsonData
            .map<Product>((product) => Product.fromJson(product))
            .toList();
      } else {
        print('Failed to load products from DB. Status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception occurred while fetching products from DB: $e');
      return [];
    }
  }
}
