part of 'nets_qr_bloc.dart';

enum NetsQrStatus {
  initialNetsQr, loadingNetsQr, successNetsQr, failedNetsQr
}

extension NetsQrStatusExtension on NetsQrStatus {
  bool get isLoading => this == NetsQrStatus.loadingNetsQr;
  bool get isSuccess => this == NetsQrStatus.successNetsQr;
  bool get isFailed => this == NetsQrStatus.failedNetsQr;
  bool get isInitial => this == NetsQrStatus.initialNetsQr;
}

class NetsQrState extends Equatable {
  final NetsQrStatus status;
  final NetsQrRequest? netsQrRequest;
  final bool? isNetsQrCodeScanned;
  final bool isNetsQrPaymentSuccess;
  final NetsQrQuery? netsQrQuery;
  final bool cancelNetsQr;
  final String? hmac;
  final String? orderNo;
  final String? createdTxnId;
  final double? paymentAmt;

  const NetsQrState({
    this.status = NetsQrStatus.initialNetsQr,
    this.netsQrRequest,
    this.isNetsQrCodeScanned,
    this.isNetsQrPaymentSuccess = false,
    this.netsQrQuery,
    this.cancelNetsQr = false,
    this.hmac,
    this.orderNo,
    this.createdTxnId,
    this.paymentAmt,
  });

  @override
  List<Object?> get props => [status, netsQrRequest, isNetsQrCodeScanned, isNetsQrPaymentSuccess, netsQrQuery, cancelNetsQr, hmac, orderNo, createdTxnId, paymentAmt];

  NetsQrState copyWith({
    NetsQrStatus? status,
    NetsQrRequest? netsQrRequest,
    bool? isNetsQrCodeScanned,
    bool? isNetsQrPaymentSuccess,
    NetsQrQuery? netsQrQuery,
    bool? cancelNetsQr,
    String? hmac,
    String? orderNo,
    String? createdTxnId,
    double? paymentAmt,
  }) => NetsQrState(
    status: status ?? this.status,
    netsQrRequest: (cancelNetsQr == true) ? null : netsQrRequest ?? this.netsQrRequest,
    isNetsQrCodeScanned: (cancelNetsQr == true) ? null : isNetsQrCodeScanned ?? this.isNetsQrCodeScanned,
    isNetsQrPaymentSuccess: (cancelNetsQr == true) ? false : isNetsQrPaymentSuccess ?? this.isNetsQrPaymentSuccess,
    netsQrQuery: (cancelNetsQr == true) ? null : netsQrQuery ?? this.netsQrQuery,
    hmac: (cancelNetsQr == true) ? null : hmac ?? this.hmac,
    orderNo: orderNo ?? this.orderNo,
    createdTxnId: createdTxnId ?? this.createdTxnId,
    paymentAmt: paymentAmt ?? this.paymentAmt,
  );

  @override
  String toString() => 'NetsQrState(status: $status, netsQrRequest: $netsQrRequest, isNetsQrCodeScanned: $isNetsQrCodeScanned, isNetsQrPaymentSuccess: $isNetsQrPaymentSuccess, hmac: $hmac)';

}