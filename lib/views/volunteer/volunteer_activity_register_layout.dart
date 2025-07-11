import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/bloc/session/session_bloc.dart';
import 'package:redeem_order_app/models/volunteer_activity_model.dart';
import 'package:redeem_order_app/services/volunteer_activity_service.dart';

class VolunteerActivityRegisterLayout extends StatefulWidget {
  final VolunteerActivity activity;

  const VolunteerActivityRegisterLayout({super.key, required this.activity});

  @override
  State<VolunteerActivityRegisterLayout> createState() => _VolunteerActivityRegisterLayoutState();
}

class _VolunteerActivityRegisterLayoutState extends State<VolunteerActivityRegisterLayout> {
  bool _isLoading = false;

  Future<void> _register() async {
    setState(() => _isLoading = true);

    try {
      final userId = context.read<SessionBloc>().state.userId;

      if (userId == 0) {
        throw Exception('You must log in to register for an activity.');
      }

      final success = await VolunteerActivityService.registerForActivity(
        userId,
        widget.activity.activityId,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully registered for this activity!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You may have already registered.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activity = widget.activity;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Activity: ${activity.title}", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Text(activity.description),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _register,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Confirm Registration"),
            ),
          ),
        ],
      ),
    );
  }
}
