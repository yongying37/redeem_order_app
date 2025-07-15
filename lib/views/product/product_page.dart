import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/bloc/ordertype/ordertype_bloc.dart';
import 'package:redeem_order_app/bloc/cart/cart_bloc.dart';
import 'package:redeem_order_app/models/product_model.dart';
import 'package:redeem_order_app/services/product_service.dart';
import 'package:redeem_order_app/views/cart/cart_page.dart';
import 'package:redeem_order_app/widgets/cart_badge_icon.dart';
import 'product_tile.dart';

class ProductPage extends StatefulWidget {
  final String merchantId;
  final String selectedOrderType;
  final String stallName;

  const ProductPage({
    super.key,
    required this.merchantId,
    required this.selectedOrderType,
    required this.stallName,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<List<Product>> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = ProductService.fetchProducts(merchantId: widget.merchantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.stallName} - ${widget.selectedOrderType}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, 'reset_order_type');
          },
        ),
        actions: [
          CartBadgeIcon(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<OrderTypeBloc>(context),
                        child: CartPage(
                          supportsDinein: widget.selectedOrderType == 'Dine In',
                          supportsTakeaway: widget.selectedOrderType == 'Takeaway',
                          stallName: widget.stallName,
                        ),
                      ),
                  ),
                );
              },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available.'));
          }

          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) =>
                ProductTile(product: products[index]),
          );
        },
      ),
    );
  }
}
