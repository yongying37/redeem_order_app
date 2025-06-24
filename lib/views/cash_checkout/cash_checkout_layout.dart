import 'package:flutter/material.dart';

class CashCheckoutLayout extends StatelessWidget {
  final String orderNumber;
  final VoidCallback onPaymentDone;

  const CashCheckoutLayout({
    Key? key,
    required this.orderNumber,
    required this.onPaymentDone,
  }) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Order is submitted to stall!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Order Number',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            orderNumber,
            style: const TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
            child: Text(
              'Please proceed to the stall to make payment to confirm your order.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: onPaymentDone,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(
                horizontal: 32, vertical: 12),
              ),
            child: const Text('Payment Done'),
            ),
          ],
        ),
      );
  }

}