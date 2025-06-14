import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:redeem_order_app/models/merchant_model.dart';
import 'package:redeem_order_app/utils/hmac_util.dart';

class MerchantService {
  static Future<List<Merchant>> fetchMerchants() async {
    const requestUrl =
        'https://stg.foodservices.openapipaas.com/api/v1/common/org/b7ad3a7e-513d-4f5b-a7fe-73363a3e8699/locations/outlets/merchants?location_code=HawkerCentre@BCHC';

    final headers = HmacUtil.generateHeaders(
      apiKey: 'PcnpwcP9tVIoXfhntINa',
      projectId: '4cc3db29-abe6-43d8-8c73-806349e18206',
      platformSyscode: '100',
      secretKey: '5KKew8s6m8gxYzrseZZY',
      requestMethod: 'GET',
      requestUrl: requestUrl,
    );

    try {
      final response = await http.get(Uri.parse(requestUrl), headers: headers);

      print('📡 Status Code: ${response.statusCode}');
      print('📦 Raw Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData == null ||
            jsonData['result'] == null ||
            jsonData['result']['data'] == null) {
          print('⚠️ Warning: "result.data" field is null or missing in response.');
          return [];
        }

        final merchants = jsonData['result']['data'] as List;
        print('✅ API returned merchant count: ${merchants.length}');

        return merchants.map((merchant) => Merchant.fromJson(merchant)).toList();
      } else {
        print('❌ Failed to load merchants. Status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❗ Exception occurred while fetching merchants: $e');
      return [];
    }
  }
}
