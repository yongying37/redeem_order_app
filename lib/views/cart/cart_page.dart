import 'package:flutter/material.dart';
import 'cart_layout.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:CartLayout(),
    );
  }
}