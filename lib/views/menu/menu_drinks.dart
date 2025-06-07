import 'package:flutter/material.dart';
import 'package:redeem_order_app/views/cart/cart_page.dart';
import 'package:redeem_order_app/views/cart/cart_manager.dart';

class DrinksMenuPage extends StatefulWidget {
  final String selectedOrderType;
  final String stallName;
  final bool supportsDinein;
  final bool supportsTakeaway;

  const DrinksMenuPage({
    Key? key,
    required this.selectedOrderType,
    required this.stallName,
    required this.supportsDinein,
    required this.supportsTakeaway,
  }) : super(key: key);


  @override
  State<DrinksMenuPage> createState() => _DrinksMenuPageState();
}

class _DrinksMenuPageState extends State<DrinksMenuPage> {
  final Map<int, int> _quantities = {}; // index -> quantity

  final List<Map<String, String>> drinks = [
    {'image': 'assets/images/coffee.jpg', 'name': 'Coffee', 'price': '\$1.00'},
    {'image': 'assets/images/tea.jpg', 'name': 'Tea', 'price': '\$1.00'},
    {'image': 'assets/images/milo.jpg', 'name': 'Milo', 'price': '\$1.20'},
    {'image': 'assets/images/lemon_tea.jpg', 'name': 'Lemon Tea', 'price': '\$0.80'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drinks Menu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(
                  stallName: widget.stallName,
                  supportsDinein: widget.supportsDinein,
                  supportsTakeaway: widget.supportsTakeaway,
                  selectedOrderType: widget.selectedOrderType,
                ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: drinks.length,
          itemBuilder: (context, index) {
            final drink = drinks[index];
            final quantity = _quantities[index] ?? 1;

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            drink['image']!,
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          drink['name']!,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          drink['price']!,
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () {
                                setState(() {
                                  if (quantity > 1) {
                                    _quantities[index] = quantity - 1;
                                  }
                                });
                              },
                            ),
                            Text('$quantity'),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () {
                                setState(() {
                                  _quantities[index] = quantity + 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        CartManager().addItem(CartItem(
                          name: drink['name']!,
                          price: drink['price']!,
                          image: drink['image']!,
                          quantity: quantity,
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${drink['name']} (x$quantity) added to cart")),
                        );
                      },
                      child: const Text('Add to Cart', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
