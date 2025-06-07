import 'package:flutter/material.dart';
import 'package:redeem_order_app/views/stall/stall_page.dart';
import 'package:redeem_order_app/views/order_type/order_type_manager.dart';

class OrderTypeLayout extends StatelessWidget {
  const OrderTypeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "How would you like to order?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                OrderTypeManager.selectedType = 'Dine In';
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const StallPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Dine In"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                OrderTypeManager.selectedType = 'Take Out';
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const StallPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Take Out"),
            ),
          ],
        ),
      ),
    );
  }
}
