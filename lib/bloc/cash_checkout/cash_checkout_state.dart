part of 'cash_checkout_bloc.dart';

enum CashCheckoutStatus {
  initial, submitting, success, failure
}

class CashCheckoutState extends Equatable {
  final CashCheckoutStatus status;
  final String? txnId;
  final String? retrievalRef;
  final String? orderNo;
  final String? errorMsg;

  const CashCheckoutState ({
    this.status = CashCheckoutStatus.initial,
    this.txnId,
    this.retrievalRef,
    this.orderNo,
    this.errorMsg,
  });

  CashCheckoutState copyWith({
    CashCheckoutStatus? status,
    String? txnId,
    String? retrievalRef,
    String? orderNo,
    String? errorMessage,
  }) {
    return CashCheckoutState(
      status: status ?? this.status,
      txnId: txnId ?? this.txnId,
      retrievalRef: retrievalRef ?? this.retrievalRef,
      orderNo: orderNo ?? this.orderNo,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }

  @override
  List<Object?> get props => [status, txnId, retrievalRef, orderNo, errorMsg];

}