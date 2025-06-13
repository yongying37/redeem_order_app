part of 'checkout_bloc.dart';

sealed class CheckoutEvent {
  const CheckoutEvent();
}

class LoadCheckout extends CheckoutEvent {}

class ApplyPoints extends CheckoutEvent {
  final int pointsUsed;
  const ApplyPoints(
      this.pointsUsed
  );
}

class SelectPaymentMethod extends CheckoutEvent {
  final String method;
  const SelectPaymentMethod(this.method);
}