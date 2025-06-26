import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/bloc/profile/profile_bloc.dart';
import 'package:redeem_order_app/models/volunteer_activity_model.dart';
import 'package:redeem_order_app/views/profile/update_profile_page.dart';

class ProfileLayout extends StatelessWidget {
  const ProfileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.account_circle, size: 30),
                        const SizedBox(width: 10),
                        Text(state.username, style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'update') {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateProfilePage(
                                username: state.username,
                                phone: state.contactNumber,
                                email: state.email,
                                password: state.password,
                                cfmPassword: state.cfmPassword,
                              ),
                            ),
                          );

                          if (result == true) {
                          }
                        } else if (value == 'logout') {
                          // Handle logout logic here
                        }
                      },

                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'update',
                          child: Text('Update Profile'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'logout',
                          child: Text('Log Out'),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text("Current Points", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text("${state.points} points", style: const TextStyle(fontSize: 18)),
                ),
                const Divider(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("History of Volunteer Work", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.activityList.length,
                  itemBuilder: (context, index) {
                    final activity = state.activityList[index];
                    return Column(
                      children: [
                        _volunteerCard(activity),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _volunteerCard(VolunteerActivity activity) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activity.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("Location: ${activity.location}"),
            Text("Date / Time: ${activity.dateTime}"),
            Text("Points received: ${activity.points}"),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  side: const BorderSide(color: Colors.grey, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Learn More", style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
