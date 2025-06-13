import 'package:flutter/material.dart';
import 'package:redeem_order_app/views/cart/cart_manager.dart';
import 'package:redeem_order_app/views/checkout/checkout_page.dart';
import 'package:redeem_order_app/views/order_type/order_type_manager.dart';

class CartLayout extends StatefulWidget {
  final bool supportsDinein;
  final bool supportsTakeaway;
  final String stallName;
  final String selectedOrderType;

  const CartLayout({
    super.key,
    required this.supportsDinein,
    required this.supportsTakeaway,
    required this.stallName,
    required this.selectedOrderType,
  });

  @override
  State<CartLayout> createState() => _CartLayoutState();
}

class _CartLayoutState extends State<CartLayout> {
  int selectedDiscount = 0;

  @override
  void initState() {
    super.initState();
    if (OrderTypeManager.selectedType.isEmpty) {
      if (widget.supportsDinein) {
        OrderTypeManager.selectedType = 'Dine In';
      } else if (widget.supportsTakeaway) {
        OrderTypeManager.selectedType = 'Take Away';
      }
    }
  }

  void showRedeemDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Redeem Points", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                const Text("200 points available", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                _buildRedeemOption("\$1 off", 100),
                _buildRedeemOption("\$2 off", 200),
                _buildRedeemOption("\$3 off", 300),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, minimumSize: const Size(double.infinity, 50)),
                  child: const Text("Redeem Now"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRedeemOption(String label, int points) {
    return ListTile(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("$points points"),
          Radio<int>(
            value: points,
            groupValue: selectedDiscount,
            onChanged: (value) {
              setState(() {
                selectedDiscount = value!;
              });
              Navigator.pop(context);
              showRedeemDialog();
            },
          )
        ],
      ),
      onTap: () {
        setState(() {
          selectedDiscount = points;
        });
        Navigator.pop(context);
        showRedeemDialog();
      },
    );
  }

  double calculateTotal() {
    double total = 0.0;
    for (final item in CartManager().items) {
      double price = double.tryParse(item.price.replaceAll('\$', '')) ?? 0.0;
      total += price * item.quantity;
    }
    total -= selectedDiscount / 100.0;
    return total < 0 ? 0 : total;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
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
                  'Cart',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: CartManager().items.length,
              itemBuilder: (context, index) {
                final item = CartManager().items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item.image,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.price,
                                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        setState(() {
                                          if (item.quantity > 1) {
                                            item.quantity--;
                                          } else {
                                            CartManager().items.removeAt(index);
                                          }
                                        });
                                      },
                                    ),
                                    Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          item.quantity++;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Order Note'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Order Info', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Text("Order Type: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.selectedOrderType),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Collection Time'),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: Text(
              selectedDiscount > 0 ? 'Offer Applied!' : 'Enjoy discounts with your points',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedDiscount > 0 ? Colors.green : Colors.black,
              ),
            ),
            onTap: showRedeemDialog,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total \$${calculateTotal().toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14, color: Colors.red),
                    ),
                    if (selectedDiscount > 0)
                      Text(
                        'Saved \$${(selectedDiscount / 100).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 12, color: Colors.green),
                      ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: () {
                    // Checkout logic
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => const CheckoutPage()),
                    );
                  },
                  child: const Text('Check Out'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
