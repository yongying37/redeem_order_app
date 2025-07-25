import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:redeem_order_app/models/volunteer_activity_model.dart';
import 'package:redeem_order_app/views/volunteer/volunteer_activity_register_page.dart';
import 'package:redeem_order_app/bloc/session/session_bloc.dart';
import 'package:redeem_order_app/views/login/login_page.dart';

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
              const Icon(Icons.location_on, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(activity.locationName),
              ),
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
                final userId = context.read<SessionBloc>().state.userId;

                if (userId == 0) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Login Required!'),
                      content: const Text('You need to log in to register for this activity.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                            );
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                } else {
                  // User is logged in
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VolunteerActivityRegisterPage(activity: activity),
                    ),
                  );
                }
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
