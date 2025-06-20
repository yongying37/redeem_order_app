import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class NetsQrRequest extends Equatable {
  final num netsQrTxnId;
  final String netsQrRetrievalRef;
  final num amount;
  final Uint8List netsQrPayment;
  final int networkCode;
  final String instruction;
  final String netsQrResponseCode;

  const NetsQrRequest({
    required this.netsQrTxnId,
    required this.netsQrRetrievalRef,
    required this.amount,
    required this.netsQrPayment,
    required this.networkCode,
    required this.instruction,
    required this.netsQrResponseCode,
  });

  @override
  List<Object> get props => [netsQrTxnId, netsQrRetrievalRef, amount, netsQrPayment];

  static fromJson(Map<String, dynamic> json) {
    return NetsQrRequest(
      netsQrTxnId: json['txn_nets_qr_id'] as int,
      netsQrRetrievalRef: json['txn_retrieval_ref'] as String,
      amount: json['amt_in_dollars'] as num,
      networkCode: json['network_status'] as int,
      instruction: json['instruction'] as String,
      netsQrResponseCode: json['response_code'] as String,
      netsQrPayment: base64.decode(json['qr_code']),
    );
  }
}