import 'package:flutter/material.dart';
import '../home/home_layout.dart';
import 'cash_checkout_layout.dart';

class CashCheckoutPage extends StatelessWidget {
  final String orderNumber;
  final String userId;
  const CashCheckoutPage({Key? key, required this.orderNumber, required this.userId}) : super(key: key);

  void _handlePaymentDone(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment Confirmed. Thank you!')),
    );
  }

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
          onPaymentDone: () => _handlePaymentDone(context)
      ),
    );
  }

}