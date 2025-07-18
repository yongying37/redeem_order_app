import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/models/merchant_model.dart';
import 'package:redeem_order_app/services/merchant_service.dart';
import 'package:redeem_order_app/views/ordertype_stalls/ordertype_page.dart';
import 'package:redeem_order_app/bloc/cart/cart_bloc.dart';
import 'package:redeem_order_app/bloc/session/session_bloc.dart';
import 'package:redeem_order_app/views/login/login_page.dart';
import 'package:redeem_order_app/bloc/ordertype/ordertype_bloc.dart';
import 'package:redeem_order_app/views/home/home_layout.dart';

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
            print('Merchant: name=${merchant.name}, unit=${merchant.unitNo}, image=${merchant.imageUrl}');
            return InkWell(
              onTap: () async {
                final sessionState = context.read<SessionBloc>().state;
                final isLoggedIn = sessionState.userId != 0;

                if (!isLoggedIn) {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Login Required!'),
                      content: const Text('You need to log in to place an order.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context), // Close the alert
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );

                  final updatedSession = context.read<SessionBloc>().state;
                  if (updatedSession.userId == 0) return;
                }

                final cartState = context.read<CartBloc>().state;

                final hasCartItems = cartState.cartItems.isNotEmpty;
                final currentMerchantId = hasCartItems ? cartState.cartItems.first.merchantId : null;

                if (hasCartItems && currentMerchantId != merchant.id) {
                  final shouldClear = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear Cart?'),
                        content: const Text('Your cart has items from another stall. Do you wish to clear the cart and continue?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Clear Cart'),
                          ),
                        ],
                      ),
                  );

                  if (shouldClear != true) return;

                  context.read<CartBloc>().add(ClearCart());

                }

                final result = await Navigator.push(
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

                if (result == 'reset_order_type') {
                  context.read<OrderTypeBloc>().add(const ResetOrderType());

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeLayout()),
                        (_) => false,
                  );
                }
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
