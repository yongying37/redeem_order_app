part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartItem> cartItems;
  final int pointsUsed;

  const CartState({
    this.cartItems = const [],
    this.pointsUsed = 0,
  });

  double get total {
    double subtotal = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
    return (subtotal - (pointsUsed / 100.0)).clamp(0, double.infinity);
  }

  CartState copyWith ({List<CartItem>? cartItems, int? pointsUsed,}) {
    return CartState(cartItems: cartItems ?? this.cartItems, pointsUsed: pointsUsed ?? this.pointsUsed);
  }

  @override
  List<Object?> get props => [cartItems, pointsUsed];

}