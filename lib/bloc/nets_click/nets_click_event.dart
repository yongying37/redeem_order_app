part of 'nets_click_bloc.dart';

sealed class NetsClickEvent extends Equatable {
  const NetsClickEvent();

  @override
  List<Object?> get props => [];
}

final class MakePayment extends NetsClickEvent {
  final PaymentDetails mainPaymentDetails;
  final int userId;
  final String orderType;
  final List<CartItem> cartItems;
  final double totalAmount;
  final int pointsUsed;

  const MakePayment({
    required this.mainPaymentDetails,
    required this.userId,
    required this.orderType,
    required this.cartItems,
    required this.totalAmount,
    required this.pointsUsed,
  });

  @override
  List<Object?> get props => [
    mainPaymentDetails,
    userId,
    orderType,
    cartItems,
    totalAmount,
    pointsUsed
  ];
}

final class CompleteNetsClickCheckout extends NetsClickEvent {
  final int userId;
  final String orderType;
  final List<CartItem> cartItems;
  final double paymentAmount;
  final int pointsUsed;

  const CompleteNetsClickCheckout({
    required this.userId,
    required this.orderType,
    required this.cartItems,
    required this.paymentAmount,
    required this.pointsUsed,
  });

  @override
  List<Object?> get props => [userId, orderType, cartItems, paymentAmount, pointsUsed];
}