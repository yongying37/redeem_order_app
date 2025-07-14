import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ordertype_event.dart';
part 'ordertype_state.dart';

class OrderTypeBloc extends Bloc<OrderTypeEvent, OrderTypeState> {
  OrderTypeBloc(): super(const OrderTypeState()) {
    on<SelectOrderType>((event, emit) {
      emit(state.copyWith(
        selectedOption: event.orderType,
        status: OrderTypeStatus.selected,
      ));
    });

    on<CfmOrderType>((event, emit) {
      if (state.selectedOption != null) {
        emit(state.copyWith(status: OrderTypeStatus.confirmed));
      }
    });

    on<ResetOrderType>((event, emit) {
      emit(const OrderTypeState());
    });
  }
}