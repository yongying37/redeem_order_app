import 'package:redeem_order_app/utils/config.dart';
import 'package:redeem_order_app/models/cart_item_model.dart';

class OrderPayloadUtil {
  static Map<String, dynamic> buildPayload({
    required List<CartItem> cartItems,
    required String orderType,
  }) {
    return {
      "merchant_id": cartItems.first.merchantId,
      "org_id": "b7ad3a7e-513d-4f5b-a7fe-73363a3e8699",
      "account_id": "COMMON_ID_WEB_FOODSERVICES",
      "order_syscode": orderType.toLowerCase() == "take away" ? 2 : 4,
      "platform_syscode": Config().devPlatformSyscode,
      "txn_order_consumer_details": cartItems
          .where((item) => item.productId != null || item.id.isNotEmpty)
          .map((item) => item.toOrderJson())
          .toList(),
    };

  }
}
