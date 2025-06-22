import 'package:equatable/equatable.dart';
import 'package:redeem_order_app/utils/logger.dart';

class NetsClickPurchaseResponseDto extends Equatable {
  final String userId;
  final String txnId;
  final int txnNetsClickId;
  final String txnRetrievalRef;
  final num amtInDollars;
  final num amtInCents;
  final String responseCode;
  final String txnCryptogram;
  final int networkStatus;
  final int txnStatus;
  final String instruction;

  const NetsClickPurchaseResponseDto({
    required this.userId,
    required this.txnId,
    required this.txnNetsClickId,
    required this.txnRetrievalRef,
    required this.amtInDollars,
    required this.amtInCents,
    required this.responseCode,
    required this.txnCryptogram,
    required this.networkStatus,
    required this.txnStatus,
    required this.instruction,
  });

  @override
  List<Object?> get props => [
    userId,
    txnId,
    txnNetsClickId,
    txnRetrievalRef,
    amtInDollars,
    amtInCents,
    responseCode,
    txnCryptogram,
    networkStatus,
    txnStatus,
    instruction,
  ];

  // fromJson
  factory NetsClickPurchaseResponseDto.fromJson(Map<String, dynamic> json) {
    try {
      return NetsClickPurchaseResponseDto(
        userId: json['user_id'],
        txnId: json['txn_id'],
        txnNetsClickId: json['txn_nets_click_id'] as int,
        txnRetrievalRef: json['txn_retrieval_ref'],
        amtInDollars: num.parse(json['amt_in_dollars'].toString()),
        amtInCents: num.parse(json['amt_in_cents'].toString()),
        responseCode: json['response_code'],
        txnCryptogram: json['txn_cryptogram'],
        networkStatus: json['network_status'] as int,
        txnStatus: json['txn_status'] as int,
        instruction: json['instruction'],
      );
    } catch (error, stackTrace) {
      Logger.e(error.toString(), stackTrace: stackTrace, tag: 'NetsClickPurchaseResponseDto.fromJson');
      rethrow;
    }
  }
}
