import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/bloc/checkout/checkout_bloc.dart';
import 'package:redeem_order_app/bloc/cart/cart_bloc.dart';
import 'package:redeem_order_app/bloc/session/session_bloc.dart';
import 'package:redeem_order_app/models/cart_item_model.dart';
import 'package:redeem_order_app/services/create_order_service.dart';
import 'package:redeem_order_app/services/record_order_service.dart';
import 'package:redeem_order_app/utils/order_payload_util.dart';
import 'package:redeem_order_app/views/home/home_layout.dart';

class CashCheckoutLayout extends StatefulWidget {
  final String orderNumber;
  final String orderType;
  final List<CartItem> cartItems;

  const CashCheckoutLayout({
    Key? key,
    required this.orderNumber,
    required this.orderType,
    required this.cartItems,
  }) : super (key: key);

  @override
  State<CashCheckoutLayout> createState() => _CashCheckoutLayoutState();
}

class _CashCheckoutLayoutState extends State<CashCheckoutLayout> {
  bool isProcessing = false;
  bool orderSubmitted = false;

  Future<void> _onPaymentDone() async {
    final userId = context.read<SessionBloc>().state.userId;

    if (userId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please login to place an order")),
      );
      return;
    }

    setState(() {
      isProcessing = true;
      orderSubmitted = false;
    }
    );

    try {
      final payload = OrderPayloadUtil.buildPayload(
          cartItems: widget.cartItems,
          orderType: widget.orderType,
      );
      final result = await OrderService.createOrder(orderPayload: payload);
      final txnId = result['txn_id'];
      final retrievalRef = result['txn_retrieval_ref'];

      print ('Order created!');

      await RecordOrderService().submitOrderToDB(
          userId: userId,
          cartItems: widget.cartItems,
          paymentMethod: "Cash",
          paymentAmt: context.read<CheckoutBloc>().state.total,
          pointsUsed: context.read<CartBloc>().state.pointsUsed,
          orderType: widget.orderType,
      );

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Order created!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Transacation ID:\n$txnId"),
              const SizedBox(height: 8),
              Text("Retrieval Ref:\n$retrievalRef"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Done"),
            ),
          ],
        ),
      );

      setState(() {
        orderSubmitted = true;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order failed: $e")),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isProcessing
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    orderSubmitted ? 'Order is submitted to stall!'
                    : 'Submitting Order to stall...',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Order Number',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.orderNumber,
                    style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                    child: Text(
                      orderSubmitted ? 'Payment has been made! Please make your way to the stall to collect your order'
                      : 'Please proceed to the stall to make payment to confirm your order.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (orderSubmitted) {
                        Navigator.pushAndRemoveUntil(
                          context, 
                          MaterialPageRoute(builder: (_) => const HomeLayout()),
                            (route) => false,
                        );
                      }
                      else {
                        _onPaymentDone();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text( orderSubmitted ? 'Return to Homepage' : 'Payment Done'),
                  ),
                ],
            ),
      ),
    );
  }

}