import 'package:flutter/material.dart';

class DrinksMenuPage extends StatelessWidget {
  const DrinksMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drinks Menu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Drinks Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 4,  // Number of drinks
              itemBuilder: (context, index) {
                // List of drinks with images, names, and prices
                final drinks = [
                  {'image': 'assets/images/coffee.jpg', 'name': 'Coffee', 'price': '\$1.00'},
                  {'image': 'assets/images/tea.jpg', 'name': 'Tea', 'price': '\$1.00'},
                  {'image': 'assets/images/milo.jpg', 'name': 'Milo', 'price': '\$1.20'},
                  {'image': 'assets/images/lemon_tea.jpg', 'name': 'Lemon Tea', 'price': '\$0.80'},
                ];

                final drink = drinks[index];

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          drink['image']!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        drink['name']!,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        drink['price']!,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Add functionality to add to order
                        },
                        child: const Text('Add to Order'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
