import 'package:equatable/equatable.dart';

class NetsClickPurchaseRequestDto extends Equatable {
  final String userId;
  final String txnId;
  final int txnNetsClickId;
  final String amtInDollars;

  const NetsClickPurchaseRequestDto({
    required this.userId,
    required this.txnId,
    required this.txnNetsClickId,
    required this.amtInDollars,
  });

  @override
  List<Object?> get props => [
    userId,
    txnId,
    txnNetsClickId,
    amtInDollars,
  ];

  // toJson
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['txn_id'] = txnId;
    data['txn_nets_click_id'] = txnNetsClickId;
    data['amt_in_dollars'] = amtInDollars;
    return data;
  }
}
