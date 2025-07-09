import 'package:flutter/material.dart';
import 'package:redeem_order_app/views/volunteer/volunteer_organization_layout.dart';
import 'package:redeem_order_app/views/home/home_layout.dart';

class VolunteerOrganizationPage extends StatelessWidget {
  const VolunteerOrganizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeLayout()),
            );
          },
        ),
      ),
      body: const VolunteerOrganizationLayout(),
    );
  }
}
