import 'package:flutter/material.dart';
import 'package:redeem_order_app/views/menu/menu_drinks.dart';
import '../stall/stall_page.dart';
import 'ordertype_layout.dart';

class OrderTypesPage extends StatelessWidget {
  final String stallName;
  final bool supportsDinein;
  final bool supportsTakeaway;

  const OrderTypesPage({
    Key? key,
    required this.stallName,
    required this.supportsDinein,
    required this.supportsTakeaway,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Type Page - Drinks'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
              Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const StallPage()),
              );
          }
        )
      ),
      body: OrderTypesLayout(
        supportsDinein: supportsDinein,
        supportsTakeaway: supportsTakeaway,
        stallName: stallName,
        onContinue: (String selectedOption) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DrinksMenuPage(
              selectedOrderType: selectedOption,
              stallName: stallName,
              supportsDinein: supportsDinein,
              supportsTakeaway: supportsTakeaway,
              ),
            ),
          );
        },
      ),

    );
  }
}
