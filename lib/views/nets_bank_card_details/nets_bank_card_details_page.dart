import 'package:flutter/material.dart';
import 'package:redeem_order_app/models/nets_bank_card_model.dart';
import 'nets_bank_card_details_layout.dart';

class NetsBankCardDetailsPage extends StatelessWidget {
  final NetsBankCard netsBankCard;
  const NetsBankCardDetailsPage({super.key, required this.netsBankCard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NETs Bank Card Details', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: NetsBankCardDetailsLayout(netsBankCard: netsBankCard),
    );
  }
}