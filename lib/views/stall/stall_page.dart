import 'package:flutter/material.dart';
import 'stall_layout.dart';
import 'package:redeem_order_app/views/home/home_layout.dart';

class StallPage extends StatelessWidget {
  final String userId;
  const StallPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Stalls'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeLayout(userId: userId)),
            );
          },
        ),
      ),
      body: StallLayout(userId: userId),
    );
  }
}
