import 'package:flutter/material.dart';

import 'nets_click_layout.dart';

class NetsClickPage extends StatelessWidget {
  const NetsClickPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Payment', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: const NetsClickLayout(),
    );
  }

}