import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:redeem_order_app/bloc/cart/cart_bloc.dart';
import 'package:redeem_order_app/models/cart_item_model.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CartBloc cartBloc;

  static const double takeawayCharge = 0.50;

  CheckoutBloc({required this.cartBloc}) : super(CheckoutState.initial()) {
    on<LoadCheckout>(_onLoadCheckout);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
    on<UpdateOrderType>(_onUpdateOrderType);
  }

  void _onLoadCheckout(LoadCheckout event, Emitter<CheckoutState> emit) {
    final cartItems = cartBloc.state.cartItems;
    final pointsUsed = cartBloc.state.pointsUsed;
    double total = _calculateTotal(cartItems, pointsUsed, event.orderType);
    emit(state.copyWith(cartItems: cartItems, total: total, pointsUsed: pointsUsed, orderType: event.orderType));
  }

  void _onSelectPaymentMethod(SelectPaymentMethod event, Emitter<CheckoutState> emit) {
    emit(state.copyWith(paymentMethod: event.method));
  }

  void _onUpdateOrderType(UpdateOrderType event, Emitter<CheckoutState> emit) {
    final cartItems = cartBloc.state.cartItems;
    final pointsUsed = cartBloc.state.pointsUsed;
    double total = _calculateTotal(cartItems, pointsUsed, event.orderType);
    emit(state.copyWith(orderType: event.orderType, total: total));
  }

  double _calculateTotal(List<CartItem> items, int pointsUsed, String orderType) {
    double total = 0.0;
    for (final item in items) {
      total += item.price * item.quantity;

      if (orderType.toLowerCase() == 'take away') {
        total += takeawayCharge * item.quantity;
      }

    }

    total -= pointsUsed / 100.0;

    return total < 0 ? 0.0 : total;
  }

}