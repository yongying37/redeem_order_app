import 'package:flutter/material.dart';
import 'package:redeem_order_app/models/product_model.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: product.productImgUrl.isNotEmpty
            ? Image.network(product.productImgUrl, width: 60, fit: BoxFit.cover)
            : const Icon(Icons.fastfood, size: 40),
        title: Text(product.productName),
        trailing: Text('\$${product.productPrice.toStringAsFixed(2)}'),
      ),
    );
  }
}
