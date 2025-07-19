import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/bloc/cart/cart_bloc.dart';
import 'package:redeem_order_app/bloc/cash_checkout/cash_checkout_bloc.dart';
import 'package:redeem_order_app/bloc/profile/profile_bloc.dart';
import 'package:redeem_order_app/bloc/session/session_bloc.dart';
import 'package:redeem_order_app/models/cart_item_model.dart';
import 'package:redeem_order_app/views/home/home_layout.dart';

class CashCheckoutLayout extends StatelessWidget {
  final String orderType;
  final List<CartItem> cartItems;
  final double totalAmount;

  const CashCheckoutLayout({
    Key? key,
    required this.orderType,
    required this.cartItems,
    required this.totalAmount,
  }) : super (key: key);

  void _handleSubmit(BuildContext context) {
    final userId = context.read<SessionBloc>().state.userId;
    final pointsUsed = context.read<CartBloc>().state.pointsUsed;

    context.read<CashCheckoutBloc>().add(
      SubmitCashOrderEvent(
          userId: userId,
          orderType: orderType,
          paymentAmount: totalAmount,
          cartItems: cartItems,
          pointsUsed: pointsUsed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CashCheckoutBloc, CashCheckoutState>(
      listener: (context, state) {
        if (state.status == CashCheckoutStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Order failed: ${state.errorMsg}")),
          );
        }

        if (state.status == CashCheckoutStatus.success) {
          final userId = context.read<SessionBloc>().state.userId;
          context.read<ProfileBloc>().add(LoadProfile(userId));

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Order Submitted!'),
              content: const Text('Your order is now being prepared.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        final isProcessing = state.status == CashCheckoutStatus.submitting;
        final isSubmitted = state.status == CashCheckoutStatus.success;

        return Scaffold(
          body: Center(
            child: isProcessing
                ? const CircularProgressIndicator()
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isSubmitted ? 'Order is submitted to stall!'
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
                  state.orderNo ?? '---',
                  style: const TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                  child: Text(
                    isSubmitted ? 'Payment has been made! Please make your way to the stall to collect your order'
                        : 'Please proceed to the stall to make payment to confirm your order.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (isSubmitted) {
                      context.read<CartBloc>().add(ClearCart());
                      Navigator.pop(context, 'reset_order_type');
                    }
                    else {
                      _handleSubmit(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text(isSubmitted ? 'Return to Homepage' : 'Payment Done'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
