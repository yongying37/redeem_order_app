import 'package:flutter/material.dart';
import 'package:redeem_order_app/models/payment_details_model.dart';

import 'nets_click_loader_layout.dart';

class NetsClickLoaderPage extends StatelessWidget {
  final PaymentDetails mainPaymentDetails;
  final String userId;
  const NetsClickLoaderPage({super.key, required this.mainPaymentDetails, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NetsClickLoaderLayout(mainPaymentDetails: mainPaymentDetails, userId: userId),
    );
  }
}