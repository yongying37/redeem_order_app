import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/services/order_history_service.dart';
import 'package:redeem_order_app/models/order_history_model.dart';
import 'orderhistory_event.dart';
import 'orderhistory_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final OrderHistoryService orderService;

  OrderHistoryBloc(this.orderService) : super(OrderHistoryInitial()) {
    on<FetchOrderHistory>(_onFetchOrderHistory);
  }

  Future<void> _onFetchOrderHistory(
      FetchOrderHistory event,
      Emitter<OrderHistoryState> emit,
      ) async {
    emit(OrderHistoryLoading());
    try {
      final List<OrderHistory> orders = await orderService.fetchMinimalOrderHistory(event.userId);
      emit(OrderHistoryLoaded(orders));
    } catch (e) {
      emit(OrderHistoryError("Failed to load order history."));
    }
  }
}
