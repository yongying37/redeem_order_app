import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/bloc/cart/cart_bloc.dart';
import 'package:redeem_order_app/bloc/checkout/checkout_bloc.dart';
import 'package:redeem_order_app/bloc/ordertype/ordertype_bloc.dart';
import 'package:redeem_order_app/bloc/profile/profile_bloc.dart';
import 'package:redeem_order_app/views/checkout/checkout_page.dart';
import 'package:redeem_order_app/models/cart_item_model.dart';
import 'package:redeem_order_app/models/order_history_model.dart';

class CartLayout extends StatefulWidget {
  final bool supportsDinein;
  final bool supportsTakeaway;
  final String stallName;
  final OrderHistory? prefilledProduct;
  final String? prefilledOrderType;

  const CartLayout({
    super.key,
    required this.supportsDinein,
    required this.supportsTakeaway,
    required this.stallName,
    this.prefilledProduct,
    this.prefilledOrderType,
  });

  @override
  State<CartLayout> createState() => _CartLayoutState();
}

class _CartLayoutState extends State<CartLayout> {
  int tempSelectedDis = 0;

  @override
  void initState() {
    super.initState();

    final product = widget.prefilledProduct;
    final type = widget.prefilledOrderType;

    if (product != null && type != null) {
      // Set order type (Dine In or Takeaway)
      context.read<OrderTypeBloc>().add(SelectOrderType(type));

      // Add to cart if not already in it
      context.read<CartBloc>().add(AddItem(
        CartItem(
          id: product.productName.hashCode.toString(),
          name: product.productName,
          price: product.productPrice,
          quantity: 1,
          imgUrl: product.productImage,
          productId: product.productId,
          merchantId: product.merchantId,
        ),
      ));
    }
  }

  void showRedeemDialog() {
    tempSelectedDis = 0;

    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) {
              final availablePoints = profileState.points;
              return StatefulBuilder(
                builder: (context, setStateDialog) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Redeem Points",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 4),
                          Text("$availablePoints points available",
                              style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 20),
                          _buildRedeemOption("\$1 off", 100, availablePoints, setStateDialog),
                          _buildRedeemOption("\$2 off", 200, availablePoints, setStateDialog),
                          _buildRedeemOption("\$3 off", 300, availablePoints, setStateDialog),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: tempSelectedDis <= availablePoints && tempSelectedDis > 0 ? () {
                              context.read<CartBloc>().add(RedeemPoints(tempSelectedDis));
                              Navigator.pop(context);
                            } : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text("Redeem Now"),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
        );
      },
    );
  }

  Widget _buildRedeemOption(String label, int points, int availablePoints, void Function(void Function()) setStateDialog) {
    final cartTotal = context.read<CartBloc>().state.total;
    final discountValue = points / 100.0;
    final isDisabled = points > availablePoints || discountValue > cartTotal;

    return ListTile(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(label, style: TextStyle(color: isDisabled ? Colors.grey : Colors.black,
      fontWeight: isDisabled ? FontWeight.normal : FontWeight.bold)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("$points points", style: TextStyle(color: isDisabled ? Colors.grey : Colors.black)),
          Radio<int>(
            value: points,
            groupValue: tempSelectedDis,
            onChanged: isDisabled ? null : (value) {
              setStateDialog(() {
                tempSelectedDis = value!;
              });
            },
          )
        ],
      ),
      onTap: isDisabled ? null : () {
        setStateDialog(() {
          tempSelectedDis = points;
        });
        Navigator.pop(context);
        showRedeemDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderType = context
        .select((OrderTypeBloc bloc) => bloc.state.selectedOption) ??
        'Not selected';

    return SafeArea(
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final items = state.cartItems;

          double total = state.total;
          total = total < 0 ? 0 : total;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Text(
                      'Cart',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text("Cart is empty."))
                    : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.imgUrl,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image,
                                      size: 48, color: Colors.grey),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 4),
                                    Text("\$${item.price.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey)),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            if (item.quantity > 1) {
                                              context.read<CartBloc>().add(
                                                  UpdateItemQuantity(
                                                      item.id,
                                                      item.quantity - 1));
                                            } else {
                                              context
                                                  .read<CartBloc>()
                                                  .add(RemoveItem(item.id));
                                            }
                                          },
                                        ),
                                        Text('${item.quantity}',
                                            style: const TextStyle(
                                                fontSize: 14)),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            context.read<CartBloc>().add(
                                                UpdateItemQuantity(item.id,
                                                    item.quantity + 1));
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Order Info',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    Row(
                      children: [
                        const Text("Order Type: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(orderType),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Collection Time'),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Now'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: Text(
                  state.pointsUsed > 0
                      ? 'Offer Applied!'
                      : 'Enjoy discounts with your points',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: state.pointsUsed > 0 ? Colors.green.shade600 : Colors.black,
                  ),
                ),
                onTap: showRedeemDialog,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total \$${total.toStringAsFixed(2)}',
                          style:
                          const TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold,),
                        ),
                        if (state.pointsUsed > 0)
                          Text(
                            'Saved \$${(state.pointsUsed / 100).toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.green.shade600,),
                          ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                      ),
                      onPressed: state.cartItems.isEmpty ? null : () async {
                        final orderType = context.read<OrderTypeBloc>().state.selectedOption ?? '';
                        context.read<CheckoutBloc>().add(LoadCheckout(orderType));
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CheckoutPage(orderType: orderType),
                          ),
                        );

                        if (result == 'reset_order_type') {
                          Navigator.pop(context, 'reset_order_type');
                        }
                      },
                      child: const Text('Check Out'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
