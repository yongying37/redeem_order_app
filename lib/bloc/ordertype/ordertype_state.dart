part of 'ordertype_bloc.dart';

enum OrderTypeStatus {
  initial, selected, confirmed
}

class OrderTypeState extends Equatable {
  final String? selectedOption;
  final OrderTypeStatus status;

  const OrderTypeState({
  this.selectedOption,
  this.status = OrderTypeStatus.initial});

  @override
  List<Object?> get props => [selectedOption, status];

  OrderTypeState copyWith ({
    String? selectedOption,
    OrderTypeStatus? status,
  }) {
    return OrderTypeState(
      selectedOption: selectedOption ?? this.selectedOption,
      status: status ?? this.status,
    );
  }
}