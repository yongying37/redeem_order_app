import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/dtos/nets_click_purchase_response_dto.dart';
import '../../dtos/nets_click_purchase_request_dto.dart';
import '../../models/payment_details_model.dart';
import '../../repositories/api_repository.dart';
import '../../utils/config.dart';
import '../../utils/logger.dart';

part 'nets_click_event.dart';
part 'nets_click_state.dart';

class NetsClickBloc extends Bloc<NetsClickEvent, NetsClickState> {
  final ApiRepository _apiRepository = ApiRepository();

  Future<void> _validatePaymentDetails(MakePayment event) async {
    // validate main payment amount
    if (num.parse(event.mainPaymentDetails.amtInDollars) <= 0) {
      throw Exception('Main payment amount is invalid. Amount must be greater than 0');
    }
  }

  String _generateTxnId(MakePayment event) {
    /*String txnId = '';
    // main payment
    txnId = '${Config().openApiPaasProjectName}|${Config().mainPaymentCredentialSource}|${event.mainPaymentDetails.identifier}|${event.mainPaymentDetails.recordId}';
    return txnId;*/
    return '${Config().openApiPaasProjectName}|'
        '${Config().mainPaymentCredentialSource}|'
        '${event.mainPaymentDetails.identifier}|'
        '${event.mainPaymentDetails.recordId}';
  }

  Future<String?> _handleNetsClickPurchaseResponse(NetsClickPurchaseResponseDto netsClickPurchaseResponse) async {
    if (netsClickPurchaseResponse.networkStatus == 0) {
      throw '${netsClickPurchaseResponse.networkStatus}. \n${netsClickPurchaseResponse.instruction}';
    }

    if (netsClickPurchaseResponse.responseCode == '00') {
      return null;
    }

    if (netsClickPurchaseResponse.responseCode == '75') {
      throw 'Pin tries exceeded. Please try again.';
    }

    throw 'Main Payment failed (${netsClickPurchaseResponse.responseCode}).';
  }


  NetsClickBloc() : super(const NetsClickState()) {
    on<MakePayment>((event, emit) async {
      try {
        // update the state to loading
        emit(state.copyWith(
          status: NetsClickStatus.makePaymentLoading,
          loadingTitle: 'Processing main payment',
          loadingMessage: 'Verifying payment details. Please wait...',
        ));

        // validate payment details
        await _validatePaymentDetails(event);

        // check if NETS is available
        String netsClickHealthResponseCode = await _apiRepository.checkNetsClickHealth();
        if (netsClickHealthResponseCode != '00') {
          throw 'NETS payment is currently unavailable ($netsClickHealthResponseCode). Please try again later.';
        }

        // update loading message
        emit(state.copyWith(
          status: NetsClickStatus.makePaymentLoading,
          loadingMessage: 'Generating essential payment details for main payment. Please wait...',
        ));

        // update loading message
        emit(state.copyWith(
          status: NetsClickStatus.makePaymentLoading,
          loadingMessage: 'Successfully generated essential payment details for main payment. Sending main payment details to our server...',
        ));

        // format txn_id
        String txnId = _generateTxnId(event);

        // format payment details into nets click purchase request dto
        NetsClickPurchaseRequestDto mainNetsClickPurchaseRequest = NetsClickPurchaseRequestDto(
          userId: Config().userId,
          txnId: txnId,
          txnNetsClickId: Config().netsBankCardId,
          amtInDollars: event.mainPaymentDetails.amtInDollars,
        );


        // update loading message
        emit(state.copyWith(
          status: NetsClickStatus.makePaymentLoading,
          loadingMessage: 'Talking to our payment server. Please wait...',
        ));

        // send main purchase request to server
        NetsClickPurchaseResponseDto mainNetsClickPurchaseResponse = await _apiRepository.mainNetsClickPurchase(mainNetsClickPurchaseRequest);

        // check if main purchase is successful.
        await _handleNetsClickPurchaseResponse(mainNetsClickPurchaseResponse);

        // update the state to success with success title and message
        emit(state.copyWith(
            status: NetsClickStatus.makePaymentSuccess,
            successTitle: 'Payment Success',
            successMessage: 'Your payment have been received. Thank you for using our services. Please proceed to the stall to collect your food!'));

      } catch (e, s) {
        Logger.e(e.toString(), stackTrace: s, tag: 'ManagePaymentBloc.MakePayment');
        emit(NetsClickState(status: NetsClickStatus.makePaymentError, errorTitle: 'Checkout Error', errorMessage: '$e'));
      }
    });
  }
}
