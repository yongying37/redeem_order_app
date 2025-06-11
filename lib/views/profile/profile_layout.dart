import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../models/volunteer_activity_model.dart';

class ProfileLayout extends StatelessWidget {
  const ProfileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.account_circle, size: 30),
                      const SizedBox(width: 10),
                      Text("Welcome, ${state.username}", style: const TextStyle(fontSize: 18)),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("History of Volunteer Work", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
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
                  const Divider(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("Update Your Particulars Here", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 10),

                  _editableField("Username", state.username, (val) => _update(context, username: val)),
                  _editableField("Phone", state.phoneNumber, (val) => _update(context, phoneNumber: val)),
                  _editableField("Email", state.email, (val) => _update(context, email: val)),
                  _editableField("Password", state.password, (val) => _update(context, password: val)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  void _update(BuildContext context, {String? username, String? phoneNumber, String? email, String? password}) {
    final bloc = context.read<ProfileBloc>();
    final state = bloc.state;
    bloc.add(UpdateProfile(
        username ?? state.username,
        password ?? state.password,
        email ?? state.email,
        phoneNumber ?? state.phoneNumber,
    ));
  }

  Widget _editableField(String label, String initialValue, Function(String) onSubmitted) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        controller: TextEditingController(text: initialValue),
        onSubmitted: onSubmitted,
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

  /*@override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle, size: 30),
              SizedBox(width: 10),
              Text("Welcome, <username>", style: TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Current Points", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("5200 pts", style: TextStyle(fontSize: 18)),
          const Divider(height: 30),
          const Text("Past History of Volunteer Work", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _volunteerCard(
                  title: "Volunteer Activity 1",
                  location: "Heartbeat @ Bedok",
                  dateTime: "10 Jun 2024, 8 am",
                  points: "10 points",
                ),
                const SizedBox(height: 10),
                _volunteerCard(
                  title: "Volunteer Activity 2",
                  location: "Our Tampines Hub",
                  dateTime: "5 Jun 2024, 10 am",
                  points: "10 points",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _volunteerCard({
    required String title,
    required String location,
    required String dateTime,
    required String points,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("Location: $location"),
            Text("Date / Time: $dateTime"),
            Text("Points received: $points"),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Learn More", style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }*/
}
