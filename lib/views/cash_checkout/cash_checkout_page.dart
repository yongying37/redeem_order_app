import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/models/cart_item_model.dart';
import 'package:redeem_order_app/views/home/home_layout.dart';
import 'package:redeem_order_app/bloc/cash_checkout/cash_checkout_bloc.dart';
import 'package:redeem_order_app/bloc/profile/profile_bloc.dart';
import 'cash_checkout_layout.dart';

class CashCheckoutPage extends StatelessWidget {
  final String orderType;
  final List<CartItem> cartItems;
  final double totalAmount;

  const CashCheckoutPage({
    Key? key,
    required this.orderType,
    required this.cartItems,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CashCheckoutBloc()),
        BlocProvider.value(value: BlocProvider.of<ProfileBloc>(context)),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cash Checkout'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const HomeLayout()),
                );
              }
          ),
        ),
        body: CashCheckoutLayout(
          orderType: orderType,
          cartItems: cartItems,
          totalAmount: totalAmount,
        ),
      )
    );
  }

}