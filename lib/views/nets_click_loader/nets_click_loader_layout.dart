import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/models/payment_details_model.dart';
import 'package:redeem_order_app/models/cart_item_model.dart';
import 'package:redeem_order_app/bloc/nets_click/nets_click_bloc.dart';
import 'package:redeem_order_app/bloc/session/session_bloc.dart';
import 'package:redeem_order_app/bloc/cart/cart_bloc.dart'; 
import 'package:redeem_order_app/bloc/profile/profile_bloc.dart'; 
import 'package:redeem_order_app/utils/config.dart';

class NetsClickLoaderLayout extends StatefulWidget {
  final PaymentDetails mainPaymentDetails;
  final String orderType;
  final List<CartItem> cartItems;
  final double totalAmount;

  const NetsClickLoaderLayout({
    super.key,
    required this.mainPaymentDetails,
    required this.orderType,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  State<NetsClickLoaderLayout> createState() => _NetsClickLoaderLayoutState();
}

class _NetsClickLoaderLayoutState extends State<NetsClickLoaderLayout> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<NetsClickBloc>(context).add(MakePayment(
        mainPaymentDetails:  widget.mainPaymentDetails,
        userId: context.read<SessionBloc>().state.userId,
        orderType: widget.orderType,
        cartItems: widget.cartItems,
        totalAmount: widget.totalAmount,
        pointsUsed: context.read<CartBloc>().state.pointsUsed,
    ));
  }

  Widget renderLoadingScreen(NetsClickState netsClickState) {
    if (netsClickState.status.isMakePaymentError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(netsClickState.errorTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              Config().redCrossPath, fit: BoxFit.cover, width: 180,),
          ),
          Text(netsClickState.errorMessage, textAlign: TextAlign.center),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Go back'),
          ),
        ],
      );
    } else if (netsClickState.status.isMakePaymentLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20,),
          Text(netsClickState.loadingTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          Text(netsClickState.loadingMessage, textAlign: TextAlign.center),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(netsClickState.successTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(Config().greenTickPath, fit: BoxFit.cover, width: 180,),
          ),
          Text(netsClickState.successMessage, textAlign: TextAlign.center),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, 'reset_order_type');
            },
            child: const Text('Go back'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetsClickBloc, NetsClickState>(
      listener: (context, state) async {
        final userId = context.read<SessionBloc>().state.userId;
        if (state.status.isMakePaymentSuccess && state.orderNo != null) {
          context.read<ProfileBloc>().add(LoadProfile(userId));
          context.read<CartBloc>().add(ClearCart());

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Order created!"),
              content: Text("Your order number is ${state.orderNo}!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      },
      child: BlocBuilder<NetsClickBloc, NetsClickState>(
        builder: (context, netsClickState) {
          return PopScope(
            canPop: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: renderLoadingScreen(netsClickState)),
            ),
          );
        },
      ),
    );
  }
}