import 'package:flutter/material.dart';
import 'package:redeem_order_app/models/payment_details_model.dart';
import 'package:redeem_order_app/models/cart_item_model.dart';
import 'nets_click_loader_layout.dart';

class NetsClickLoaderPage extends StatelessWidget {
  final PaymentDetails mainPaymentDetails;
  final String userId;
  final String orderType;
  final List<CartItem> cartItems;

  const NetsClickLoaderPage({
    super.key,
    required this.mainPaymentDetails,
    required this.userId,
    required this.orderType,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NetsClickLoaderLayout(
          mainPaymentDetails: mainPaymentDetails,
          userId: userId,
          orderType: orderType,
          cartItems: cartItems,
      ),
    );
  }
}