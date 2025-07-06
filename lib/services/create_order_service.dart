import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:redeem_order_app/utils/hmac_util.dart';
import 'package:redeem_order_app/utils/config.dart';

class OrderService {
  static const String baseUrl = 'https://stg.foodservices.openapipaas.com/api/v1/hub/foodcanopy/transactions/orders';

  static Future<Map<String, dynamic>> createOrder({
    required Map<String, dynamic> orderPayload,
  }) async {

    final String requestUrl = '$baseUrl';
    final String requestBody = json.encode(orderPayload);

    // Debugging
    print('Request Body Sent: \n$requestBody');

    // Generate secure headers using HMAC
    final headers = HmacUtil.generateHeaders(
        apiKey: Config().devApiKey,
        projectId: Config().devProjectId,
        platformSyscode: Config().devPlatformSyscode.toString(),
        secretKey: Config().devSecretKey,
        requestMethod: 'POST',
        requestUrl: requestUrl,
        requestBody: requestBody,
    );

    headers['Host'] = 'stg.foodservices.openapipaas.com';
    headers.remove('host');

    print('Sending Create Order Request...');
    print('Final Payload: $requestBody');
    print('Final Headers: ');
    headers.forEach((key, value) => print('  $key: $value'));
    print('Full URL: $requestUrl');
    final response = await http.post(
      Uri.parse(requestUrl),
      headers: headers,
      body: requestBody,
      encoding: Encoding.getByName('utf-8'),
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['result']['data'];
    }
    else {
      throw Exception('Failed to create order');
    }

  }

}