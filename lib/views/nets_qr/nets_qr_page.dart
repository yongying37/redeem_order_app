import 'package:flutter/material.dart';

import 'nets_qr_layout.dart';

class NetsQrPage extends StatelessWidget {
  final String userId;
  final String orderType;

  const NetsQrPage({super.key, required this.orderType, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NetsQrLayout(orderType: orderType, userId: userId),
    );
  }
}