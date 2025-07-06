/*import 'package:redeem_order_app/bloc/checkout/checkout_bloc.dart';
import 'package:redeem_order_app/utils/config.dart';*/
import 'package:redeem_order_app/models/cart_item_model.dart';


class OrderPayloadUtil {
  static Map<String, dynamic> buildPayload({
    required List<CartItem> cartItems,
    required String orderType,
  }) {
    return {
      "merchant_id": "a6542f9c-1f61-4b72-a529-7a8c85f1cff4",
      "org_id": "b7ad3a7e-513d-4f5b-a7fe-73363a3e8699",
      "account_id": "COMMON_ID_WEB_FOODSERVICES",
      "order_syscode": 4,
      "platform_syscode": 100,
      "txn_order_consumer_details": [
        {
          "product_id": "1eb240a1-dbcd-4918-b050-5b34be60ffb0",
          "order_qty": "1",
          "txn_order_consumer_add_ons": [
            {
              "product_id": "0a96a2a4-fffd-4909-a735-3f24f0d7d013",
              "add_on_qty": 1
            }
          ],
          "order_pref": "Less Sugar, No Ice",
          "order_remarks": ""
        }
      ]
    };
  }
}
