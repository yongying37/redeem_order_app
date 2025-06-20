import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:redeem_order_app/bloc/nets_qr/nets_qr_bloc.dart';
import 'package:redeem_order_app/bloc/cart/cart_bloc.dart';
import 'package:redeem_order_app/bloc/checkout/checkout_bloc.dart';
import 'package:redeem_order_app/views/checkout/checkout_page.dart';

class TxnNetsFailStatusLayout extends StatefulWidget {
  final String orderType;

  const TxnNetsFailStatusLayout({super.key, required this.orderType});

  @override
  State<TxnNetsFailStatusLayout> createState() => _TxnNetsFailStatusLayoutState();
}

class _TxnNetsFailStatusLayoutState extends State<TxnNetsFailStatusLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.asset('assets/images/redCross.png'),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'TRANSACTION FAILED',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              btnFail(),
            ],
          ),
        ),
      ),
    );
  }

  Widget btnFail() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        // Dispatch the cancellation event
        BlocProvider.of<NetsQrBloc>(context).add(const CancelWebhookNetsQrEvent());

        final cartBloc = context.read<CartBloc>();
        final orderType = widget.orderType;

        // Ensure navigation happens after the current frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: cartBloc),
                  BlocProvider(
                    create: (_) => CheckoutBloc(cartBloc: cartBloc)
                      ..add(LoadCheckout(orderType)),
                  ),
                ],
                child: CheckoutPage(orderType: orderType),
              ),
            ),
          );
        });
      },
      child: const Padding(
        padding: EdgeInsets.all(15.0),
        child: Text(
          'BACK TO CHECK OUT PAGE',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
