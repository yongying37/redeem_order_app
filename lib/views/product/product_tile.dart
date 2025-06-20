import 'package:flutter/material.dart';
import 'package:redeem_order_app/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../../models/cart_item_model.dart';

class ProductTile extends StatefulWidget {
  final Product product;

  const ProductTile({super.key, required this.product});

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  int quantity = 1;

  void increment() {
    setState(() {
      quantity++;
    });
  }

  void decrement() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            // Product image
            widget.product.productImgUrl.isNotEmpty
                ? Image.network(
              widget.product.productImgUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            )
                : const Icon(Icons.fastfood, size: 40),

            const SizedBox(width: 12),

            // Product name
            Expanded(
              child: Text(widget.product.productName),
            ),

            // Quantity + Price + Add Button
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('\$${widget.product.productPrice.toStringAsFixed(2)}'),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),
                      onPressed: decrement,
                    ),
                    Text(quantity.toString(), style: const TextStyle(fontSize: 14)),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      onPressed: increment,
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    final cartBloc = context.read<CartBloc>();

                    cartBloc.add(
                      AddItem(
                        CartItem(
                          id: UniqueKey().toString(),
                          name: widget.product.productName,
                          price: widget.product.productPrice,
                          imgUrl: widget.product.productImgUrl,
                          quantity: quantity,
                        ),
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added $quantity item(s) to cart')),
                    );

                    setState(() {
                      quantity = 1; // Reset quantity
                    });
                  },
                  child: const Text("Add"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    textStyle: const TextStyle(fontSize: 12),
                    backgroundColor: Colors.green.shade300,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
