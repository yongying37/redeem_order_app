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