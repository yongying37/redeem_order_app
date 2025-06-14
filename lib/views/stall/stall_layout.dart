import 'package:flutter/material.dart';
import 'package:redeem_order_app/models/merchant_model.dart';
import 'package:redeem_order_app/services/merchant_service.dart';
import 'package:redeem_order_app/views/ordertype_stalls/ordertype_page.dart';

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
            print('📦 Merchant: name=${merchant.name}, unit=${merchant.unitNo}, image=${merchant.imageUrl}');
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderTypesPage(
                      stallName: merchant.name,
                      supportsDinein: merchant.supportsDineIn,
                      supportsTakeaway: merchant.supportsTakeaway,
                      organisationId: 'b7ad3a7e-513d-4f5b-a7fe-73363a3e8699',
                      merchantId: merchant.id,
                    ),
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  leading: merchant.imageUrl.isNotEmpty
                      ? Image.network(
                    merchant.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.store),
                  )
                      : const Icon(Icons.store),
                  title: Text(merchant.name),
                  subtitle: Text(
                    merchant.unitNo.isNotEmpty ? 'Unit: ${merchant.unitNo}' : 'Unit: Not Available',
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
