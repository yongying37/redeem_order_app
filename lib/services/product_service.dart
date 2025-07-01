import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:redeem_order_app/models/product_model.dart';
import 'package:redeem_order_app/utils/hmac_util.dart';
import 'package:redeem_order_app/utils/config.dart';

class ProductService {
  static Future<List<Product>> fetchMerchantProducts({
    required String organisationId,
    required String merchantId,
    required String platformSyscode,
  }) async {
    final requestUrl =
        'https://stg.foodservices.openapipaas.com/api/v1/common/org/$organisationId/merchants/$merchantId/products?platform_syscode=$platformSyscode';

    final headers = HmacUtil.generateHeaders(
      apiKey: Config().devApiKey,
      projectId: Config().devProjectId,
      platformSyscode: Config().devPlatformSyscode,
      secretKey: Config().devSecretKey,
      requestMethod: 'GET',
      requestUrl: requestUrl,
    );

    headers['Host'] = 'stg.foodservices.openapipaas.com';

    final response = await http.get(Uri.parse(requestUrl), headers: headers);

    print('Fetching products from: $requestUrl');
    print('Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final rawData = decoded['result']['data'];

      List data;

      if (rawData is List) {
        data = rawData;
      } else if (rawData is Map) {
        data = [rawData];
      } else {
        data = [];
      }

      print('Normalized product count: ${data.length}');
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      print('Error: ${response.body}');
      throw Exception('Failed to fetch merchant products');
    }
  }
}
