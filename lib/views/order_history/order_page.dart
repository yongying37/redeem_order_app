import 'package:flutter/material.dart';
import 'order_layout.dart';

class OrderPage extends StatelessWidget {
  final int userId;
  const OrderPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrderLayout(userId: userId),
    );
  }
}
