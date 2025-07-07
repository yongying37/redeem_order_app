import 'package:flutter/material.dart';
import 'stall_layout.dart';
import 'package:redeem_order_app/views/home/home_layout.dart';

class StallPage extends StatelessWidget {
  const StallPage({super.key});

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
              MaterialPageRoute(builder: (context) => HomeLayout()),
            );
          },
        ),
      ),
      body: StallLayout(),
    );
  }
}
