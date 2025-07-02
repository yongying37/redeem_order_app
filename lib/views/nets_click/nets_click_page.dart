import 'package:flutter/material.dart';

import 'nets_click_layout.dart';

class NetsClickPage extends StatelessWidget {
  final String userId;
  const NetsClickPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Payment', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: NetsClickLayout(userId: userId),
    );
  }

}