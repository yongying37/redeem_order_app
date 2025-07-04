import 'package:flutter/material.dart';
import 'txn_nets_success_status_layout.dart';

class TxnNetsSuccessStatusPage extends StatelessWidget {
  final String orderType;
  final String userId;

  const TxnNetsSuccessStatusPage({super.key, required this.orderType, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TxnNetsSuccessStatusLayout(orderType: orderType, userId: userId),
    );
  }
}