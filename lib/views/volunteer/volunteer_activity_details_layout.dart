import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redeem_order_app/models/volunteer_activity_model.dart';

class VolunteerActivityDetailsLayout extends StatelessWidget {
  final VolunteerActivity activity;

  const VolunteerActivityDetailsLayout({super.key, required this.activity});

  String _formatDateTime(String datetime) {
    try {
      final dt = DateTime.parse(datetime);
      return DateFormat('EEE, dd MMM yyyy • hh:mm a').format(dt);
    } catch (_) {
      return datetime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            activity.imageUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.volunteer_activism, size: 100),
          ),
          const SizedBox(height: 16),
          Text(activity.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(activity.description),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 20),
              const SizedBox(width: 8),
              Text(_formatDateTime(activity.datetime)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.timer, size: 20),
              const SizedBox(width: 8),
              Text("${activity.duration} minutes"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, size: 20),
              const SizedBox(width: 8),
              Text("Target: ${activity.targetAmount} points"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.category, size: 20),
              const SizedBox(width: 8),
              Text("Type: ${activity.type}"),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Implement registration logic here
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text("Register"),
            ),
          ),
        ],
      ),
    );
  }
}
