import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:redeem_order_app/models/cart_item_model.dart';
import 'package:redeem_order_app/models/record_order_model.dart';

class RecordOrderService {

  final String baseUrl = 'http://10.0.2.2:8000/api/v1';

  Future<bool> submitOrderToDB({
    required int userId,
    required List<CartItem> cartItems,
    required String paymentMethod,
    required double paymentAmt,
    required int pointsUsed,
    required String orderType,
  }) async {
    final url = Uri.parse('$baseUrl/consumer-orders');
    final now = DateTime.now().toIso8601String();

    List<RecordOrder> records = cartItems.map((item) {
      return RecordOrder(
        accountUserId: userId,
        productId: item.productId ?? '',
        productQty: item.quantity,
        paymentMode: paymentMethod,
        paymentAmt: paymentAmt,
        volunteerPointsRedeemed: pointsUsed,
        orderDatetime: now,
        orderType: orderType,
      );
    }).toList();

    List<Map<String, dynamic>> jsonList = records.map((r) => r.toJson()).toList();

    print('Submitting order to $url');
    print('Payload: ${jsonEncode(jsonList)}');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jsonList),
      );

      print('Order submit response: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Order submission error: $e');
      return false;
    }
  }
}