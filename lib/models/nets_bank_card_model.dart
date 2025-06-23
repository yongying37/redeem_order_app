import 'package:equatable/equatable.dart';

import 'package:redeem_order_app/utils/logger.dart';

class NetsBankCard extends Equatable {
  final int id;
  final String issuerShortName;
  final String paymentMode;
  final String lastFourDigit;
  final String expiryDate;

  const NetsBankCard({
    required this.id,
    required this.issuerShortName,
    required this.paymentMode,
    required this.lastFourDigit,
    required this.expiryDate,
  });

  factory NetsBankCard.fromJson(Map<String, dynamic> json) {
    try {
      return NetsBankCard(
        id: json['txn_nets_click_id'],
        issuerShortName: json['issuer_short_name'],
        paymentMode: json['payment_mode'] ?? 'nets_click',
        lastFourDigit: json['last_4_digits_fpan'],
        expiryDate: json['mtoken_expiry_date'],
      );
    } catch (e, s) {
      Logger.e(e.toString(), stackTrace: s, tag: 'netsBankCard.fromJson');
      rethrow;
    }
  }

  // toJson
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['txn_nets_click_id'] = id;
    data['issuer_short_name'] = issuerShortName;
    data['payment_mode'] = paymentMode;
    data['last_4_digits_fpan'] = lastFourDigit;
    data['mtoken_expiry_date'] = expiryDate;
    return data;
  }

  @override
  List<Object> get props => [id, issuerShortName, paymentMode, lastFourDigit, expiryDate];
}
