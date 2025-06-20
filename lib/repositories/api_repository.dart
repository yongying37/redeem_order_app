
import 'package:redeem_order_app/dtos/nets_qr_webhook_response_dto.dart';
import 'package:redeem_order_app/models/nets_qr_query_model.dart';
import 'package:redeem_order_app/models/nets_qr_request_model.dart';

import '../services/api_service.dart';

class ApiRepository {
  ApiRepository._privateConstructor();
  static final ApiRepository _instance = ApiRepository._privateConstructor();
  factory ApiRepository() => _instance;

  final ApiService service = ApiService();

  Future<NetsQrRequest> requestNetsApi(double amount, String txnId, int notifyMobile) async => service.requestNetsApi(amount, txnId, notifyMobile);

  Future<NetsQrWebhookResponseDto> webhookNetsApi(String netsQrRetrievalRef) async => service.webhookNetsApi(netsQrRetrievalRef);

  Future<void> cancelWebhookNetsApi() async => service.cancelWebhookNetsApi();

  Future<NetsQrQuery> queryNetsApi(String netsQrRetrievalRef, netsTimeoutStatus) async => service.queryNetsApi(netsQrRetrievalRef, netsTimeoutStatus);
}