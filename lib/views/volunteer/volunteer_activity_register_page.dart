import 'package:flutter/material.dart';
import 'package:redeem_order_app/models/volunteer_activity_model.dart';
import 'volunteer_activity_register_layout.dart';

class VolunteerActivityRegisterPage extends StatelessWidget {
  final VolunteerActivity activity;

  const VolunteerActivityRegisterPage({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Registration')),
      body: VolunteerActivityRegisterLayout(activity: activity),
    );
  }
}
