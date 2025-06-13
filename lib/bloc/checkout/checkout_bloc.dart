import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:redeem_order_app/views/cart/cart_manager.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(CheckoutState.initial()) {
    on<LoadCheckout>(_onLoadCheckout);
    on<ApplyPoints>(_onApplyPoints);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
  }

  void _onLoadCheckout(LoadCheckout event, Emitter<CheckoutState> emit) {
    double total = _calculateTotal(0);
    emit(state.copyWith(cartItems: CartManager().items, total: total));
  }

  void _onApplyPoints(ApplyPoints event, Emitter<CheckoutState> emit) {
    double total = _calculateTotal(event.pointsUsed);
    emit(state.copyWith(pointsUsed: event.pointsUsed, total: total));
  }

  void _onSelectPaymentMethod(SelectPaymentMethod event, Emitter<CheckoutState> emit) {
    emit(state.copyWith(paymentMethod: event.method));
  }

  double _calculateTotal(int pointsUsed) {
    double total = 0.0;
    for (final item in CartManager().items) {
      total += (double.tryParse(item.price.replaceAll('\$', '')) ?? 0.0) * item.quantity;
    }
    total -= pointsUsed / 100.0;
    return total < 0 ? 0.0 : total;
  }

}