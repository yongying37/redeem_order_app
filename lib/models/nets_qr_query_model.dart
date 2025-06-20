import 'package:equatable/equatable.dart';

class NetsQrQuery extends Equatable {
  final int netsQrTxnId;
  final String netsQrRetrievalRef;
  final String netsQrResponseCode;
  final int openApiPaasTxnStatus;

  const NetsQrQuery({
    required this.netsQrTxnId,
    required this.netsQrRetrievalRef,
    required this.netsQrResponseCode,
    required this.openApiPaasTxnStatus,
  });

  @override
  List<Object> get props => [
    netsQrTxnId,
    netsQrRetrievalRef,
    netsQrResponseCode,
    openApiPaasTxnStatus,
  ];

  static fromJson(Map<String, dynamic> json) {
    return NetsQrQuery(
      netsQrTxnId: json['txn_nets_qr_id'],
      netsQrRetrievalRef: json['txn_retrieval_ref'],
      netsQrResponseCode: json['response_code'],
      openApiPaasTxnStatus: json['txn_status'],
    );
  }
}