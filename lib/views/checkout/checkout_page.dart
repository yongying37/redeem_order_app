import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/checkout/checkout_bloc.dart';
import 'checkout_layout.dart';

class CheckoutPage extends StatelessWidget {
  final String orderType;
  const CheckoutPage({super.key, required this.orderType});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutBloc(cartBloc: context.read<CartBloc>())..add(LoadCheckout(orderType)),
      child: Scaffold(
        body: CheckoutLayout(orderType: orderType),
      ),
    );
  }
}
