import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:redeem_order_app/models/merchant_model.dart';

class MerchantService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  static Future<List<Merchant>> fetchMerchants() async {
    final url = Uri.parse('$baseUrl/merchants');

    try {
      final response = await http.get(url);

      print('Status Code: ${response.statusCode}');
      print('Raw Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData == null || jsonData is! List) {
          print('Warning: API did not return a list as expected.');
          return [];
        }

        return jsonData
            .map<Merchant>((merchant) => Merchant.fromJson(merchant))
            .toList();
      } else {
        print('Failed to load merchants from DB. Status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception occurred while fetching merchants from DB: $e');
      return [];
    }
  }
}
