part of 'ordertype_bloc.dart';

sealed class OrderTypeEvent {
  const OrderTypeEvent();
}

class SelectOrderType extends OrderTypeEvent {
  final String orderType;
  const SelectOrderType(this.orderType);
}

class CfmOrderType extends OrderTypeEvent {
  const CfmOrderType();
}

class ResetOrderType extends OrderTypeEvent {
  const ResetOrderType();
}
