import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:redeem_order_app/dtos/nets_qr_webhook_response_dto.dart';
import 'package:redeem_order_app/models/cart_item_model.dart';
import 'package:redeem_order_app/models/nets_qr_request_model.dart';
import 'package:redeem_order_app/utils/logger.dart';
import 'package:redeem_order_app/models/nets_qr_query_model.dart';
import 'package:redeem_order_app/repositories/api_repository.dart';
import 'package:redeem_order_app/services/create_order_service.dart';
import 'package:redeem_order_app/utils/order_payload_util.dart';

part 'nets_qr_state.dart';
part 'nets_qr_event.dart';

class NetsQrBloc extends Bloc<NetsQrEvent, NetsQrState> {
  final ApiRepository _apiRepository = ApiRepository();

  NetsQrBloc() : super(const NetsQrState()) {

    on<RequestNetsQrEvent>((event, emit) async {
      try {
        // emit a loading state when Request NETS QR is triggered
        emit(state.copyWith(status: NetsQrStatus.loadingNetsQr));

        // send the Request NETS QR to server
        final netsQrRequest = await _apiRepository.requestNetsApi(event.amount, event.txnId, event.notifyMobile);

        // call the Webhook NETS QR Event
        add(WebhookNetsQrEvent(netsQrRetrievalRef: netsQrRequest.netsQrRetrievalRef));

        // emit a success state and the response from the Request NETS QR
        emit(state.copyWith(status: NetsQrStatus.successNetsQr, netsQrRequest: netsQrRequest));
      } catch (e, s) {
        // log errors and emit a failed state
        Logger.e(e.toString(), stackTrace: s, tag: 'NetsQrBloc.NetsQrRequestEvent');
        emit(state.copyWith(status: NetsQrStatus.failedNetsQr));
      }
    });

    on<WebhookNetsQrEvent>((event, emit) async {
      try {
        // send the Webhook NETS QR to server
        final NetsQrWebhookResponseDto netsQrWebhookResponseDto = await _apiRepository.webhookNetsApi(event.netsQrRetrievalRef);

        // creating variables to check if NETS QR Code is scanned, and NETS QR Payment is success
        final bool isNetsQrCodeScanned = netsQrWebhookResponseDto.message == 'QR code scanned';
        final bool isNetsQrPaymentSuccess = netsQrWebhookResponseDto.netsQrResponseCode == '00';

        // emit the variables
        emit(state.copyWith(isNetsQrCodeScanned: isNetsQrCodeScanned, isNetsQrPaymentSuccess: isNetsQrPaymentSuccess));

        int netsTimeoutStatus = 0;
        if (isNetsQrCodeScanned == false) {
          netsTimeoutStatus = 1;
          add(QueryNetsQrEvent(netsQrRetrievalRef: event.netsQrRetrievalRef, netsTimeoutStatus: netsTimeoutStatus));
        }
      } catch (e, s) {
        // log errors and emit a failed state
        Logger.e(e.toString(), stackTrace: s, tag: 'NetsQrBloc.NetsQrWebhookEvent');
        emit(state.copyWith(status: NetsQrStatus.failedNetsQr));
      }
    });

    on<QueryNetsQrEvent>((event, emit) async {
      try {
        final netsQrQuery = await _apiRepository.queryNetsApi(event.netsQrRetrievalRef, event.netsTimeoutStatus);
        emit(state.copyWith(netsQrQuery: netsQrQuery));
      } catch (e, s) {
        Logger.e(e.toString(), stackTrace: s, tag: 'NetsQrBloc.NetsQrQueryEvent');
        emit(state.copyWith(status: NetsQrStatus.failedNetsQr));
      }
    });

    on<CancelWebhookNetsQrEvent>((event, emit) async {
      // send the Cancel NETS QR to server
      if (event.cancelWebhookNetsQr) {
        await _apiRepository.cancelWebhookNetsApi();
      }

      // emit the cancelNetsQr state as true
      emit(state.copyWith(cancelNetsQr: true));
    });

    on<GenerateHmacNetsQrEvent>((event, emit) {
      final String concatenatedString = event.jsonString + event.secretKey;
      List<int> bytes  = utf8.encode(concatenatedString);
      Digest hash = sha256.convert(bytes);
      String hmac = base64.encode(hash.bytes);
      emit(state.copyWith(hmac: hmac));
    });

    on<StartNETsQrFlowEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: NetsQrStatus.loadingNetsQr));
        final payload = OrderPayloadUtil.buildPayload(
            cartItems: event.cartItems,
            orderType: event.orderType
        );

        final result = await OrderService.createOrder(orderPayload: payload);
        final txnId = result['txn_id'];
        final retrievalRef = result['txn_retrieval_ref'];
        final orderNo = result['order_no'];
        final parsedAmt = (result['order_total_amt'] as num).toDouble();
        final formattedAmt = parsedAmt.toStringAsFixed(2);

        print("\n Txn ID: $txnId | Retrieval Ref: $retrievalRef | NETs Amount: $parsedAmt\n");

        add(RequestNetsQrEvent(amount: formattedAmt, txnId: txnId, notifyMobile: 0));

        emit(state.copyWith(orderNo: orderNo, createdTxnId: txnId, paymentAmt: parsedAmt));

      } catch (e, s) {
        Logger.e("Failed to start NETs QR flow: $e", stackTrace: s, tag: '');
        emit(state.copyWith(status: NetsQrStatus.failedNetsQr));
      }
    });
  }
}