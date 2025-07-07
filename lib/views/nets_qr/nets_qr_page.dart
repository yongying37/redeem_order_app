import 'package:flutter/material.dart';
import 'package:redeem_order_app/models/cart_item_model.dart';
import 'nets_qr_layout.dart';

class NetsQrPage extends StatelessWidget {
  final String orderType;
  final List<CartItem> cartItems;

  const NetsQrPage({
    super.key,
    required this.orderType,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NetsQrLayout(
          orderType: orderType,
          cartItems: cartItems
      ),
    );
  }
}