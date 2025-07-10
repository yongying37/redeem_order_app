import 'package:flutter/material.dart';
import 'package:redeem_order_app/models/volunteer_activity_model.dart';
import 'package:redeem_order_app/services/volunteer_activity_service.dart';

import 'volunteer_activity_details_page.dart';

class VolunteerActivityLayout extends StatefulWidget {
  final String organizationId;
  final String organizationName;

  const VolunteerActivityLayout({
    super.key,
    required this.organizationId,
    required this.organizationName,
  });

  @override
  State<VolunteerActivityLayout> createState() => _VolunteerActivityLayoutState();
}

class _VolunteerActivityLayoutState extends State<VolunteerActivityLayout> {
  late Future<List<VolunteerActivity>> _activities;

  @override
  void initState() {
    super.initState();
    _activities = VolunteerActivityService.fetchActivities(widget.organizationId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VolunteerActivity>>(
      future: _activities,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No volunteer activities found.'));
        }

        final activities = snapshot.data!;
        return ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  leading: ClipOval(
                    child: Image.network(
                      activity.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.volunteer_activism),
                    ),
                  ),
                  title: Text(
                    activity.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: SizedBox(
                    width: 80,
                    height: 32,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VolunteerActivityDetailsPage(activity: activity),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        textStyle: const TextStyle(fontSize: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(color: Colors.black),
                      ),
                      child: const Text("Learn More", style: TextStyle(color: Colors.black)),
                    ),
                  ),

                ),
              ),
            );
          },
        );
      },
    );
  }
}
