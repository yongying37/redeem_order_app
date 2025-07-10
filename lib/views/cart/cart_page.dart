import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/bloc/cart/cart_bloc.dart';
import 'package:redeem_order_app/models/order_history_model.dart';
import 'cart_layout.dart';

class CartPage extends StatelessWidget {
  final bool supportsDinein;
  final bool supportsTakeaway;
  final String stallName;
  final OrderHistory? prefilledProduct;
  final String? prefilledOrderType;

  const CartPage({
    super.key,
    required this.supportsDinein,
    required this.supportsTakeaway,
    required this.stallName,
    this.prefilledProduct,
    this.prefilledOrderType,
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
          prefilledProduct: prefilledProduct,
          prefilledOrderType: prefilledOrderType,
        ),
      )
    );
  }
}