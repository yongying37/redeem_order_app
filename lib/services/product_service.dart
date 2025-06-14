import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:redeem_order_app/models/product_model.dart';
import 'package:redeem_order_app/utils/hmac_util.dart';

class ProductService {
  static Future<List<Product>> fetchMerchantProducts({
    required String organisationId,
    required String merchantId,
    required String platformSyscode,
  }) async {
    final requestUrl =
        'https://stg.foodservices.openapipaas.com/api/v1/common/org/$organisationId/merchants/$merchantId/products?platform_syscode=$platformSyscode';

    final headers = HmacUtil.generateHeaders(
      apiKey: 'PcnpwcP9tVIoXfhntINa',
      projectId: '4cc3db29-abe6-43d8-8c73-806349e18206',
      platformSyscode: platformSyscode,
      secretKey: '5KKew8s6m8gxYzrseZZY',
      requestMethod: 'GET',
      requestUrl: requestUrl,
    );

    headers['Host'] = 'stg.foodservices.openapipaas.com';

    final response = await http.get(Uri.parse(requestUrl), headers: headers);

    print('📦 Fetching products from: $requestUrl');
    print('📡 Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List data = decoded['result']['data'];
      print('✅ Product count: ${data.length}');
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      print('❌ Error: ${response.body}');
      throw Exception('Failed to fetch merchant products');
    }
  }
}

