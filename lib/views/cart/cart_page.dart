import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/bloc/cart/cart_bloc.dart';
import 'cart_layout.dart';

class CartPage extends StatelessWidget {
  final bool supportsDinein;
  final bool supportsTakeaway;
  final String stallName;
  final String userId;

  const CartPage({
    super.key,
    required this.supportsDinein,
    required this.supportsTakeaway,
    required this.stallName,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CartBloc>(context),
      child: Scaffold(
        body:CartLayout(
          supportsDinein: supportsDinein,
          supportsTakeaway: supportsTakeaway,
          stallName: stallName,
          userId: userId,
        ),
      )
    );
  }
}