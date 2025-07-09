import 'package:flutter/material.dart';
import 'package:redeem_order_app/views/volunteer/volunteer_activity_layout.dart';

class VolunteerActivityPage extends StatelessWidget {
  final String organizationId;
  final String organizationName;

  const VolunteerActivityPage({
    super.key,
    required this.organizationId,
    required this.organizationName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(organizationName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: VolunteerActivityLayout(
        organizationId: organizationId,
        organizationName: organizationName,
      ),
    );
  }
}
