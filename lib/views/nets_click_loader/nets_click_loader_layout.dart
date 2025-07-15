import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/models/payment_details_model.dart';
import 'package:redeem_order_app/models/cart_item_model.dart';
import 'package:redeem_order_app/views/home/home_page.dart';
import 'package:redeem_order_app/bloc/nets_click/nets_click_bloc.dart';
import 'package:redeem_order_app/bloc/session/session_bloc.dart';
import 'package:redeem_order_app/bloc/cart/cart_bloc.dart'; 
import 'package:redeem_order_app/utils/config.dart';
import 'package:redeem_order_app/utils/order_payload_util.dart';
import 'package:redeem_order_app/services/create_order_service.dart';
import 'package:redeem_order_app/services/record_order_service.dart';

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
  bool _orderCreated = false;

  @override
  void initState() {
    super.initState();
    // Delay event dispatch until after UI loads
    Future.microtask(() {
      BlocProvider.of<NetsClickBloc>(context).add(MakePayment(widget.mainPaymentDetails));
    });
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
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => HomePage()),
                  (_) => false,
              );
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

        if (userId == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please login to place an order")),
          );
          return;
        }

        if (state.status.isMakePaymentSuccess && !_orderCreated) {
          _orderCreated = true;

          try {
            final payload = OrderPayloadUtil.buildPayload(
                cartItems: widget.cartItems,
                orderType: widget.orderType
            );

            final result = await OrderService.createOrder(orderPayload: payload);
            final txnId = result['txn_id'];
            final retrievalRef = result['txn_retrieval_ref'];
            final orderNo = result['order_no'];

            print('Order created! | Txn ID: $txnId | Retrieval Ref: $retrievalRef');

            double roundedTotal = double.parse(widget.totalAmount.toStringAsFixed(2));

            await RecordOrderService().submitOrderToDB(
              userId: userId,
              cartItems: widget.cartItems,
              paymentMethod: "NETs Click",
              paymentAmt: roundedTotal,
              pointsUsed: context.read<CartBloc>().state.pointsUsed,
              orderType: widget.orderType,
            );


            context.read<CartBloc>().add(ClearCart());

            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Order created!"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Your order number is $orderNo!"),
                  ],
                ),
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
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Order failed: $e")),
            );
          }
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