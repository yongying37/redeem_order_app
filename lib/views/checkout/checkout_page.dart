import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/checkout/checkout_bloc.dart';
import 'checkout_layout.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutBloc()..add(LoadCheckout()),
      child: const Scaffold(
        body: CheckoutLayout(),
      ),
    );
  }
}