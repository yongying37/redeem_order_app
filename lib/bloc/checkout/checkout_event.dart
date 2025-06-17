part of 'checkout_bloc.dart';

sealed class CheckoutEvent {
  const CheckoutEvent();
}

class LoadCheckout extends CheckoutEvent {
  final String orderType;
  const LoadCheckout(this.orderType);
}

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

class UpdateOrderType extends CheckoutEvent {
  final String orderType;
  const UpdateOrderType(this.orderType);
}