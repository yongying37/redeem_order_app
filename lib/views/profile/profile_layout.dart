import 'package:flutter/material.dart';

class ProfileLayout extends StatelessWidget {
  const ProfileLayout({super.key});

  @override
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
  }
}
