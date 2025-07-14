import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:redeem_order_app/models/cart_item_model.dart';
import 'package:redeem_order_app/services/create_order_service.dart';
import 'package:redeem_order_app/services/record_order_service.dart';
import 'package:redeem_order_app/utils/order_payload_util.dart';

part 'cash_checkout_event.dart';
part 'cash_checkout_state.dart';

class CashCheckoutBloc extends Bloc<CashCheckoutEvent, CashCheckoutState> {
  CashCheckoutBloc() : super(const CashCheckoutState()) {
    on<SubmitCashOrderEvent>((event, emit) async {
      emit(state.copyWith(status: CashCheckoutStatus.submitting));

      try {
        final payload = OrderPayloadUtil.buildPayload(
            cartItems: event.cartItems,
            orderType: event.orderType,
        );

        final result = await OrderService.createOrder(orderPayload: payload);
        final txnId = result['txn_id'];
        final retrievalRef = result['txn_retrieval_ref'];
        final orderNum = result['order_no'];

        print('Result for payload\n');
        print('\n${result}');

        double roundedPayment = double.parse(event.paymentAmount.toStringAsFixed(2));

        await RecordOrderService().submitOrderToDB(
            userId: event.userId,
            cartItems: event.cartItems,
            paymentMethod: "Cash",
            paymentAmt: roundedPayment,
            pointsUsed: event.pointsUsed,
            orderType: event.orderType,
        );

        emit(state.copyWith(
          status: CashCheckoutStatus.success,
          txnId: txnId,
          retrievalRef: retrievalRef,
          orderNo: orderNum,
        ));

      } catch (e) {
        emit(state.copyWith(
          status: CashCheckoutStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    });

  }
}