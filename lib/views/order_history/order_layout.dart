import 'package:flutter/material.dart';

class OrderLayout extends StatelessWidget {
  const OrderLayout({super.key});

  Widget _buildOrderCard({
    required String imagePath,
    required String title,
    required String subtitle,
    required String price,
    required String diningType,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(diningType, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Image.asset(imagePath, width: 80, height: 80, fit: BoxFit.cover),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subtitle),
                      const SizedBox(height: 4),
                      Text(price),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 90,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      textStyle: const TextStyle(fontSize: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Reorder"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "Order History",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const Text("Today", style: TextStyle(fontWeight: FontWeight.bold)),
                _buildOrderCard(
                  imagePath: 'assets/images/roasted_chicken.jpeg',
                  title: 'Roasted Chicken',
                  subtitle: 'Single Meat Rice',
                  price: '\$3.90',
                  diningType: 'Dine In',
                ),
                const SizedBox(height: 10),
                const Text("13 May 2025", style: TextStyle(fontWeight: FontWeight.bold)),
                _buildOrderCard(
                  imagePath: 'assets/images/roasted_chicken.jpeg',
                  title: 'Roasted Chicken',
                  subtitle: 'Single Meat Rice',
                  price: '\$3.90',
                  diningType: 'Dine In',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
