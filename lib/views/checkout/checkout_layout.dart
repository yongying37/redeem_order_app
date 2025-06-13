import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/views/cart/cart_manager.dart';
import '../../bloc/checkout/checkout_bloc.dart';

class CheckoutLayout extends StatelessWidget {
  const CheckoutLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          final bloc = context.read<CheckoutBloc>();
          return Column(
            children: [
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
              _buildCartTable(state.cartItems),
              ListTile(
                title: const Text("Points Used"),
                trailing: Text("${state.pointsUsed}"),
              ),
              ListTile(
                title: const Text("Total Payment"),
                trailing: Text("\$${state.total.toStringAsFixed(2)}"),
              ),
              const Divider(),
              _buildPaymentOptions(bloc, state.paymentMethod),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Order submission logic
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Submit Order"),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartTable(List<CartItem> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        children: [
          // Header row
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
                  // Image + Item Name
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            item.image,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Unit Price
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.price,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  // Quantity
                  Expanded(
                    flex: 1,
                    child: Text(
                      item.quantity.toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }


  Widget _buildPaymentOptions(CheckoutBloc bloc, String selected) {
    final methods = [
      {'name': 'Cash', 'icon': Icons.attach_money},
      {'name': 'NETS QR', 'icon': Icons.local_atm},
      {'name': 'NETS Click', 'icon': Icons.local_atm},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Payment Methods", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...methods.map((method) {
            final name = method['name'] as String;  // <-- Cast here
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
                    method.containsKey('icon')
                        ? Icon(method['icon'] as IconData, size: 28)
                        : Image.asset(method['iconAsset'] as String, width: 40, height: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }


}
