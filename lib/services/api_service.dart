import 'dart:async';
import 'dart:convert';
import 'package:redeem_order_app/dtos/nets_qr_webhook_response_dto.dart';
import 'package:redeem_order_app/dtos/nets_click_purchase_response_dto.dart';
import 'package:redeem_order_app/dtos/nets_click_purchase_request_dto.dart';
import 'package:redeem_order_app/utils/config.dart';
import 'package:redeem_order_app/http_clients/nets_http_client.dart';
import 'package:redeem_order_app/models/nets_qr_query_model.dart';
import 'package:redeem_order_app/models/nets_qr_request_model.dart';
import 'package:redeem_order_app/utils/logger.dart';

class ApiService {
  ApiService._privateConstructor();
  static final ApiService _instance = ApiService._privateConstructor();
  factory ApiService() => _instance;

  Future<NetsQrRequest> requestNetsApi(String amount, String txnId, int notifyMobile) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amt_in_dollars'] = amount;
    data['txn_id'] = txnId;
    data['notify_mobile'] = notifyMobile;

    try {
      var response = await NetsHttpClient.post(Config.apiUrls.requestNetsApi, requestBody: data);
      return NetsQrRequest.fromJson(response['result']['data']);
    } catch (e, s) {
      Logger.e(e.toString(), stackTrace: s, tag: 'ApiService.requestNetsApi');
      rethrow;
    }
  }

  Future<NetsQrWebhookResponseDto> webhookNetsApi(String netsQrRetrievalRef) async {
    try {
      NetsQrWebhookResponseDto? netsQrWebhookResponseDto;

      void onMessage(String message) {
        if (message.isNotEmpty && message.contains('message')) {
          String data = message;
          if (message.contains('data:')){
            data = message.split('data:')[1].trim();
          }
          final json = jsonDecode(data);
          print('Webhook message: $json');
          netsQrWebhookResponseDto = NetsQrWebhookResponseDto(
              message: json['message'],
              netsQrResponseCode: json['response_code']
          );
        }
      }

      StreamSubscription<String> webhookNetsQr = await NetsHttpClient.getSse(Config.apiUrls.webhookNetsApi(netsQrRetrievalRef), onMessage: onMessage, maxRetries: 1);

      while (netsQrWebhookResponseDto == null) {
        await Future.delayed(const Duration(seconds: 1));
      }

      webhookNetsQr.cancel();
      return netsQrWebhookResponseDto!;
    } catch (e, s) {
      Logger.e(e.toString(), stackTrace: s, tag: 'ApiService.webhookNetsApi');
      rethrow;
    }
  }

  Future<void> cancelWebhookNetsApi() async {
    try {
      NetsHttpClient.closeSseSubscription();
    } catch (e, s) {
      Logger.e(e.toString(), stackTrace: s, tag: 'ApiService.cancelWebhookNetsApi');
      rethrow;
    }
  }

  Future<NetsQrQuery> queryNetsApi(String netsQrRetrievalRef, int netsTimeoutStatus) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['txn_retrieval_ref'] = netsQrRetrievalRef;
    data['frontend_timeout_status'] = netsTimeoutStatus;

    try {
      var response = await NetsHttpClient.post(Config.apiUrls.queryNetsApi, requestBody: data);
      return NetsQrQuery.fromJson(response['result']['data']);
    } catch (e, s) {
      Logger.e(e.toString(), stackTrace: s, tag: 'ApiService.queryNetsApi');
      rethrow;
    }
  }

  // NETS Click
  Future<String> checkNetsClickHealth() async {
    try {
      final response = await NetsHttpClient.get(Config.apiUrls.netsHealthCheck);
      if (Config().debugMode) {
        Logger.d('checkNetsClickHealth response', jsonString: jsonEncode(response), tag: 'ApiService.checkNetsClickHealth');
      }

      String responseCode = response['result']['data']['response_code'];

      return responseCode;
    } catch (e, s) {
      Logger.e(e.toString(), stackTrace: s, tag: 'ApiService.checkNetsClickHealth');
      rethrow;
    }
  }

  Future<NetsClickPurchaseResponseDto> mainNetsClickPurchase(NetsClickPurchaseRequestDto netsClickPurchase) async {
    try {
      final Map<String, dynamic> requestBody = netsClickPurchase.toJson();
      if (Config().debugMode) {
        Logger.d('mainNetsClickPurchase request', jsonString: requestBody.toString(), tag: 'ApiService.mainNetsClickPurchase');
      }

      final response = await NetsHttpClient.post(Config.apiUrls.mainPurchaseNetsClick, requestBody: requestBody);
      if (Config().debugMode) {
        Logger.d('mainNetsClickPurchase response', jsonString: jsonEncode(response), tag: 'ApiService.mainNetsClickPurchase');
      }

      return NetsClickPurchaseResponseDto.fromJson(response['result']['data']);
    } catch (e, s) {
      Logger.e(e.toString(), stackTrace: s, tag: 'ApiService.mainNetsClickPurchase');
      rethrow;
    }
  }

}