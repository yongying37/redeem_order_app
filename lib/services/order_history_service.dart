import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redeem_order_app/models/order_history_model.dart';

class OrderHistoryService {
  final String baseUrl = 'http://10.0.2.2:8000/api/v1/consumer-orders';

  Future<List<OrderHistory>> fetchMinimalOrderHistory(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId/minimal'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => OrderHistory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load order history');
    }
  }
}
