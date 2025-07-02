import 'package:flutter/material.dart';
import 'package:redeem_order_app/views/product/product_page.dart';
import 'package:redeem_order_app/views/stall/stall_page.dart';
import 'ordertype_layout.dart';

class OrderTypesPage extends StatelessWidget {
  final String stallName;
  final bool supportsDinein;
  final bool supportsTakeaway;
  final String organisationId;
  final String merchantId;

  const OrderTypesPage({
    Key? key,
    required this.stallName,
    required this.supportsDinein,
    required this.supportsTakeaway,
    required this.organisationId,
    required this.merchantId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Order Type'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const StallPage()),
            );
          },
        ),
      ),
      body: OrderTypesLayout(
        supportsDinein: supportsDinein,
        supportsTakeaway: supportsTakeaway,
        stallName: stallName,
        onContinue: (String selectedOption) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(
                merchantId: merchantId,
                selectedOrderType: selectedOption,
                stallName: stallName,
              ),
            ),
          );
        },
      ),
    );
  }
}
