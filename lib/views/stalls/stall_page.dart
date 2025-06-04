import 'package:flutter/material.dart';
import 'stall_layout.dart';  // Import the StallLayout widget

class StallPage extends StatelessWidget {
  const StallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Stalls'),
      ),
      body: StallLayout(),  // Remove 'const' here
    );
  }
}
