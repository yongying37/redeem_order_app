import 'package:flutter/material.dart';
import 'package:redeem_order_app/models/cart_item_model.dart';
import 'package:redeem_order_app/views/home/home_layout.dart';
import 'cash_checkout_layout.dart';

class CashCheckoutPage extends StatelessWidget {
  final String orderNumber;
  final String userId;
  final String orderType;
  final List<CartItem> cartItems;

  const CashCheckoutPage({
    Key? key,
    required this.orderNumber,
    required this.userId,
    required this.orderType,
    required this.cartItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cash Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), 
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeLayout(userId: userId)),
            );
          }
        ),
      ),
      body: CashCheckoutLayout(
          orderNumber: orderNumber,
          orderType: orderType,
          userId: userId,
          cartItems: cartItems,
      ),
    );
  }

}