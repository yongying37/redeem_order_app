part of 'nets_qr_bloc.dart';

sealed class NetsQrEvent {
  const NetsQrEvent();
}

class RequestNetsQrEvent extends NetsQrEvent {
  final double amount;
  final String txnId;
  final int notifyMobile;
  const RequestNetsQrEvent({required this.amount, required this.txnId, required this.notifyMobile});
}

class WebhookNetsQrEvent extends NetsQrEvent {
  final String netsQrRetrievalRef;
  const WebhookNetsQrEvent({required this.netsQrRetrievalRef});
}

class QueryNetsQrEvent extends NetsQrEvent {
  final String netsQrRetrievalRef;
  final int netsTimeoutStatus;
  const QueryNetsQrEvent({required this.netsQrRetrievalRef, required this.netsTimeoutStatus});
}

class CancelWebhookNetsQrEvent extends NetsQrEvent {
  final bool cancelWebhookNetsQr;
  const CancelWebhookNetsQrEvent({this.cancelWebhookNetsQr = false});
}

class GenerateHmacNetsQrEvent extends NetsQrEvent {
  final String jsonString;
  final String secretKey;
  const GenerateHmacNetsQrEvent({required this.jsonString, required this.secretKey});
}

class StartNETsQrFlowEvent extends NetsQrEvent {
  final List<CartItem> cartItems;
  final String orderType;
  final double paymentAmount;
  final int userId;
  final int pointsUsed;

  const StartNETsQrFlowEvent({
    required this.cartItems,
    required this.orderType,
    required this.paymentAmount,
    required this.userId,
    required this.pointsUsed,
  });
}