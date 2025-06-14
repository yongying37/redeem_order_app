import 'package:flutter/material.dart';
import 'package:redeem_order_app/models/product_model.dart';
import 'package:redeem_order_app/services/product_service.dart';
import 'product_tile.dart';

class ProductPage extends StatefulWidget {
  final String organisationId;
  final String merchantId;
  final String selectedOrderType;
  final String stallName;

  const ProductPage({
    super.key,
    required this.organisationId,
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
    _productFuture = ProductService.fetchMerchantProducts(
      organisationId: widget.organisationId,
      merchantId: widget.merchantId,
      platformSyscode: '100',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.stallName} - ${widget.selectedOrderType}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ ${snapshot.error}'));
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
