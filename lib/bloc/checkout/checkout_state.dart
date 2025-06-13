part of 'checkout_bloc.dart';

class CheckoutState extends Equatable {
  final List<CartItem> cartItems;
  final int pointsUsed;
  final double total;
  final String paymentMethod;

  const CheckoutState({
    required this.cartItems,
    required this.pointsUsed,
    required this.total,
    required this.paymentMethod,
  });

  factory CheckoutState.initial() {
    return CheckoutState(
      cartItems: [],
      pointsUsed: 0,
      total: 0.0,
      paymentMethod: 'Cash',
    );
  }

  CheckoutState copyWith ({
    List<CartItem>? cartItems,
    int? pointsUsed,
    double? total,
    String? paymentMethod,
  }) {
    return CheckoutState(
      cartItems: cartItems ?? this.cartItems,
      pointsUsed: pointsUsed ?? this.pointsUsed,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  @override
  List<Object?> get props => [cartItems, pointsUsed, total, paymentMethod];

}