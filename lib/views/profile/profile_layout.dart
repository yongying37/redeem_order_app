import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redeem_order_app/bloc/profile/profile_bloc.dart';
import 'package:redeem_order_app/bloc/session/session_bloc.dart';
import 'package:redeem_order_app/views/home/home_page.dart';
import 'package:redeem_order_app/views/profile/update_profile_page.dart';
import 'package:redeem_order_app/models/volunteer_activity_model.dart';
import 'package:redeem_order_app/services/volunteer_activity_service.dart';

class ProfileLayout extends StatelessWidget {
  const ProfileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<SessionBloc>().state.userId;

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
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('loggedInUserId');

                          context.read<SessionBloc>().add(Logout());
                          context.read<ProfileBloc>().add(ClearProfile());

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage()),
                                (route) => false,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Successfully Logged Out.')),
                          );
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
                const SizedBox(height: 20),
                const Center(
                  child: Text("Redeemed Points", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text("${state.redeemedPoints} points", style: const TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 30),


                const Text(
                  'Registered Volunteer Activities',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                FutureBuilder<List<VolunteerActivity>>(
                  future: VolunteerActivityService.fetchRegisteredActivities(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text('No registered volunteer activities.'),
                      );
                    }

                    final activities = snapshot.data!;

                    return Column(
                      children: activities.map((activity) {
                        return Card(
                          child: ListTile(
                            leading: Image.network(
                              activity.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(activity.title),
                            subtitle: Text('${activity.orgName} • ${activity.datetime.split("T").first}'),
                          ),
                        );
                      }).toList(),
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
}
