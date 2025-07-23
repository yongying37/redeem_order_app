import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:redeem_order_app/bloc/order_history/orderhistory_bloc.dart';
import 'package:redeem_order_app/bloc/order_history/orderhistory_state.dart';
import 'package:redeem_order_app/bloc/order_history/orderhistory_event.dart';
import 'package:redeem_order_app/bloc/cart/cart_bloc.dart';
import 'package:redeem_order_app/models/order_history_model.dart';
import 'package:redeem_order_app/services/order_history_service.dart';
import 'package:redeem_order_app/views/cart/cart_page.dart';
import 'package:redeem_order_app/views/login/login_page.dart';

class OrderLayout extends StatelessWidget {
  final int userId;
  const OrderLayout({super.key, required this.userId});


  @override
  Widget build(BuildContext context) {
    if (userId == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      });

      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BlocProvider(
      create: (_) => OrderHistoryBloc(OrderHistoryService())..add(FetchOrderHistory(userId)),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Order History",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
                builder: (context, state) {
                  if (state is OrderHistoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is OrderHistoryLoaded) {
                    if (state.orders.isEmpty) {
                      return const Center(child: Text("No past orders."));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) {
                        return _buildOrderCard(state.orders[index], context);
                      },
                    );
                  } else if (state is OrderHistoryError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderHistory order, BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy').format(order.orderDatetime);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.productName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  order.orderType,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    order.productImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 80),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ordered on $formattedDate"),
                      const SizedBox(height: 4),
                      Text(
                        "\$${order.productPrice.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 3),

            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: () {
                    _showOrderTypeDialog(context, order);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    textStyle: const TextStyle(fontSize: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Reorder"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showOrderTypeDialog(BuildContext context, OrderHistory order) {
    final cartBloc = context.read<CartBloc>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Order Type'),
          content: const Text('Would you like to Dine In or Takeaway?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _goToCart(context, order, 'Dine In', cartBloc);
              },
              child: const Text('Dine In'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _goToCart(context, order, 'Take Away', cartBloc);
              },
              child: const Text('Take Away'),
            ),
          ],
        );
      },
    );
  }

  void _goToCart(BuildContext context, OrderHistory order, String orderType, CartBloc cartBloc) async {
    final cartState = cartBloc.state;
    final hasCartItems = cartState.cartItems.isNotEmpty;
    final currentMerchantId = hasCartItems ? cartState.cartItems.first.merchantId : null;

    if (hasCartItems && currentMerchantId != order.merchantId) {
      final shouldClear = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Clear Cart?'),
            content: const Text('Your cart has items from another stall. Do you wish to clear the cart and continue?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Clear Cart'),
              ),
            ],
          ),
      );

      if (shouldClear != true) return;
      cartBloc.add(ClearCart());

    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CartPage(
          stallName: 'Reorder',
          supportsDinein: true,
          supportsTakeaway: true,
          prefilledProduct: order,
          prefilledOrderType: orderType,
        ),
      ),
    );
  }
}
