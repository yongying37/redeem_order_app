import 'package:flutter/material.dart';
import 'package:redeem_order_app/models/merchant_model.dart';
import 'package:redeem_order_app/services/merchant_service.dart';

class StallLayout extends StatefulWidget {
  const StallLayout({super.key});

  @override
  State<StallLayout> createState() => _StallLayoutState();
}

class _StallLayoutState extends State<StallLayout> {
  late Future<List<Merchant>> _merchants;

  @override
  void initState() {
    super.initState();
    _merchants = MerchantService.fetchMerchants();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Merchant>>(
      future: _merchants,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No stalls available.'));
        }

        final merchants = snapshot.data!;
        return ListView.builder(
          itemCount: merchants.length,
          itemBuilder: (context, index) {
            final merchant = merchants[index];
            return Card(
              child: ListTile(
                leading: Image.network(
                  merchant.imageUrl,
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.store),
                ),
                title: Text(merchant.name),
                subtitle: Text('Unit: ${merchant.unitNo}'),
              ),
            );
          },
        );
      },
    );
  }
}
