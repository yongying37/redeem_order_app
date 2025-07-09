import 'package:flutter/material.dart';
import 'package:redeem_order_app/models/cart_item_model.dart';
import 'nets_click_layout.dart';

class NetsClickPage extends StatelessWidget {
  final String orderType;
  final List<CartItem> cartItems;
  final double totalAmount;

  const NetsClickPage({
    super.key,
    required this.orderType,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Payment', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: NetsClickLayout(
          orderType: orderType,
          cartItems: cartItems,
          totalAmount: totalAmount,
      ),
    );
  }

}