import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/bloc/checkout/checkout_bloc.dart';
import 'package:redeem_order_app/models/cart_item_model.dart';
import 'package:redeem_order_app/views/cash_checkout/cash_checkout_page.dart';
import 'package:redeem_order_app/views/nets_click/nets_click_page.dart';
import 'package:redeem_order_app/views/nets_qr/nets_qr_page.dart';
import 'package:redeem_order_app/bloc/nets_qr/nets_qr_bloc.dart';
import 'package:redeem_order_app/bloc/nets_click/nets_click_bloc.dart';

class CheckoutLayout extends StatelessWidget {
  final String orderType;
  final String userId;

  const CheckoutLayout({super.key, required this.orderType, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            final bloc = context.read<CheckoutBloc>();
            final cartItems = state.cartItems;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const Text(
                          'Checkout',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Items", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),

                  _buildCartTable(cartItems),

                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Order Type:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(orderType.isNotEmpty ? orderType : "Not selected"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtotal
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Subtotal:", style: TextStyle(fontSize: 16)),
                        Text("\$${_calculateSubtotal(cartItems).toStringAsFixed(2)}"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  if (orderType.toLowerCase() == 'take away') ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Takeaway Charge:", style: TextStyle(fontSize: 16.0)),
                          Text("+ \$${_calculateTakeawayCharge(cartItems).toStringAsFixed(2)}"),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Discount applied:", style: TextStyle(fontSize: 16.0)),
                        Text("- \$${(state.pointsUsed / 100.0).toStringAsFixed(2)}"),
                      ],
                    ),
                  ),

                  // Total
                  ListTile(
                    title: const Text("Total Payment", style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text(
                      "\$${state.total.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const Divider(),

                  _buildPaymentOptions(context, bloc, state.paymentMethod),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: state.paymentMethod.isEmpty ? null :()  {
                      if (state.paymentMethod == 'NETS QR') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (_) => NetsQrBloc(),
                              child: NetsQrPage(orderType: orderType, userId: userId, cartItems: cartItems),
                            ),
                          ),
                        );
                      }
                      else if (state.paymentMethod == 'NETS Click') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (_) => NetsClickBloc(),
                                  child: NetsClickPage(
                                      userId: userId,
                                      orderType: orderType,
                                      cartItems: cartItems,
                                  ),
                                )
                            )
                        );
                      }
                      else if (state.paymentMethod == 'Cash') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CashCheckoutPage(
                                  orderNumber: '01',
                                  userId: userId,
                                  orderType: orderType,
                                  cartItems: cartItems,
                              ),
                            ),
                        );
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order submitted with selected payment method.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white,),
                    child: const Text("Submit Order"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCartTable(List<CartItem> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(flex: 5, child: Text("Items Ordered", style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text("Unit Price", style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 1, child: Text("Qty", style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          const Divider(),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            item.imgUrl,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item.name, style: const TextStyle(fontSize: 14))),
                      ],
                    ),
                  ),
                  Expanded(flex: 2, child: Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14))),
                  Expanded(flex: 1, child: Text(item.quantity.toString(), style: const TextStyle(fontSize: 14))),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPaymentOptions(BuildContext context, CheckoutBloc bloc, String selected) {
    final methods = [
      {'name': 'Cash', 'icon': Icons.attach_money},
      {'name': 'NETS QR', 'icon': Icons.qr_code},
      {'name': 'NETS Click', 'icon': Icons.credit_card},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Payment Methods", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...methods.map((method) {
            final name = method['name'] as String;
            final isSelected = name == selected;

            return GestureDetector(
              onTap: () {
                bloc.add(SelectPaymentMethod(name));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: isSelected ? Colors.green : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(method['icon'] as IconData, size: 28),
                    const SizedBox(width: 16),
                    Expanded(child: Text(name, style: const TextStyle(fontSize: 16))),
                    if (isSelected) const Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  double _calculateSubtotal(List<CartItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  double _calculateTakeawayCharge(List<CartItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.quantity * CheckoutBloc.takeawayCharge);
  }
}
