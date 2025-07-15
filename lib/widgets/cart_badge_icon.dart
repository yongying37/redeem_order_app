import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/bloc/cart/cart_bloc.dart';

class CartBadgeIcon extends StatelessWidget {
  final VoidCallback onPressed;

  const CartBadgeIcon({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>
      (builder: (context, state) {
        final totalItems = state.cartItems.fold(0, (sum, item) => sum + item.quantity);

        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: onPressed,
            ),

            if (totalItems > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16
                  ),
                  child: Text(
                    '$totalItems',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

          ],
        );
    });
  }
}