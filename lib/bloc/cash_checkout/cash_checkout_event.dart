part of 'cash_checkout_bloc.dart';

sealed class CashCheckoutEvent extends Equatable {
  const CashCheckoutEvent();

  @override
  List<Object?> get props => [];
}

class SubmitCashOrderEvent extends CashCheckoutEvent {
  final int userId;
  final String orderType;
  final List<CartItem> cartItems;
  final double paymentAmount;
  final int pointsUsed;

  const SubmitCashOrderEvent({
    required this.userId,
    required this.orderType,
    required this.cartItems,
    required this.paymentAmount,
    required this.pointsUsed
  });

  @override
  List<Object?> get props => [userId, orderType, cartItems, paymentAmount, pointsUsed];

}