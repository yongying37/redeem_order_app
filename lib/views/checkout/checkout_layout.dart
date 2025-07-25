import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/bloc/checkout/checkout_bloc.dart';
import 'package:redeem_order_app/bloc/nets_qr/nets_qr_bloc.dart';
import 'package:redeem_order_app/bloc/nets_click/nets_click_bloc.dart';
import 'package:redeem_order_app/models/cart_item_model.dart';
import 'package:redeem_order_app/models/nets_bank_card_model.dart';
import 'package:redeem_order_app/models/payment_details_model.dart';
import 'package:redeem_order_app/views/cash_checkout/cash_checkout_page.dart';
import 'package:redeem_order_app/views/nets_click_loader/nets_click_loader_page.dart';
import 'package:redeem_order_app/views/nets_qr/nets_qr_page.dart';
import 'package:redeem_order_app/widgets/bank_card_widget.dart';
import 'package:redeem_order_app/utils/config.dart';

class CheckoutLayout extends StatelessWidget {
  final String orderType;

  const CheckoutLayout({super.key, required this.orderType});

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
                    onPressed: state.paymentMethod.isEmpty ? null : () async {
                      dynamic result;

                      if (state.paymentMethod == 'NETS QR') {
                        result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (_) => NetsQrBloc(),
                              child: NetsQrPage(
                                orderType: orderType,
                                cartItems: cartItems,
                                totalAmount: state.total,
                              ),
                            ),
                          ),
                        );
                      } else if (state.paymentMethod == 'NETS Click') {
                        final mainPaymentDetails = PaymentDetails(
                            amtInDollars: state.total.toStringAsFixed(2),
                            recordId: '1',
                            identifier: Config().mainPaymentIdentifier,
                        );

                        result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (_) => NetsClickBloc(),
                              child: NetsClickLoaderPage(
                                mainPaymentDetails: mainPaymentDetails,
                                orderType: orderType,
                                cartItems: cartItems,
                                totalAmount: state.total,
                              ),
                            ),
                          ),
                        );
                      } else if (state.paymentMethod == 'Cash') {
                        result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CashCheckoutPage(
                              orderType: orderType,
                              cartItems: cartItems,
                              totalAmount: state.total,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order submitted with selected payment method.')),
                        );
                      }

                      if (result == 'reset_order_type') {
                        Navigator.pop(context, 'reset_order_type');
                      }
                    },

                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white,),
                    child: const Text("Pay"),
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

    final netsBankCard = NetsBankCard(
        id: Config().netsBankCardId,
        issuerShortName: 'TEST',
        paymentMode: 'NETS Click',
        lastFourDigit: '1234',
        expiryDate: '12/27',
    );

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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
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
                ),
                if (isSelected && name == 'NETS Click') ...[
                  const SizedBox(height: 8), 
                  BankCard(netsBankCard: netsBankCard, width: MediaQuery.of(context).size.width * 0.85),
                ]
              ],
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
