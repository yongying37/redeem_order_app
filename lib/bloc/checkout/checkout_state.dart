part of 'checkout_bloc.dart';

class CheckoutState extends Equatable {
  final List<CartItem> cartItems;
  final int pointsUsed;
  final double total;
  final String paymentMethod;
  final String orderType;

  const CheckoutState({
    required this.cartItems,
    required this.pointsUsed,
    required this.total,
    required this.paymentMethod,
    this.orderType = '',
  });

  factory CheckoutState.initial() {
    return const CheckoutState(
      cartItems: [],
      pointsUsed: 0,
      total: 0.0,
      paymentMethod: 'Cash',
      orderType: '',
    );
  }

  CheckoutState copyWith ({
    List<CartItem>? cartItems,
    int? pointsUsed,
    double? total,
    String? paymentMethod,
    String? orderType,
  }) {
    return CheckoutState(
      cartItems: cartItems ?? this.cartItems,
      pointsUsed: pointsUsed ?? this.pointsUsed,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderType: orderType ?? this.orderType,
    );
  }

  @override
  List<Object?> get props => [cartItems, pointsUsed, total, paymentMethod, orderType];

}