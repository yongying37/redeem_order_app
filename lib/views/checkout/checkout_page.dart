import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/bloc/cart/cart_bloc.dart';
import 'package:redeem_order_app/bloc/checkout/checkout_bloc.dart';
import 'checkout_layout.dart';

class CheckoutPage extends StatelessWidget {
  final String orderType;
  final String userId;
  const CheckoutPage({super.key, required this.orderType, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutBloc(cartBloc: context.read<CartBloc>())..add(LoadCheckout(orderType)),
      child: Scaffold(
        body: CheckoutLayout(orderType: orderType, userId: userId),
      ),
    );
  }
}
