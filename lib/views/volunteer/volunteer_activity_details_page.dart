import 'package:flutter/material.dart';
import 'package:redeem_order_app/models/volunteer_activity_model.dart';
import 'package:redeem_order_app/views/volunteer/volunteer_activity_details_layout.dart';
class VolunteerActivityDetailsPage extends StatelessWidget {
  final VolunteerActivity activity;

  const VolunteerActivityDetailsPage({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activity.title),
      ),
      body: VolunteerActivityDetailsLayout(activity: activity),
    );
  }
}
