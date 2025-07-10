abstract class OrderHistoryEvent {}

class FetchOrderHistory extends OrderHistoryEvent {
  final int userId;

  FetchOrderHistory(this.userId);
}
