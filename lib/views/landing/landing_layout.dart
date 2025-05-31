import 'package:flutter/material.dart';
import 'package:redeem_order_app/views/home/home_layout.dart';

class LandingLayout extends StatefulWidget {
  const LandingLayout({super.key});

  @override
  State<LandingLayout> createState() => _LandingLayoutState();
}

class _LandingLayoutState extends State<LandingLayout> {
  
  Widget displayTitle() {
    return const Text(
        'Foodgle Hub',
      style: TextStyle(color: Colors.black, fontSize: 32)
    );
  }

  Widget btnGetStarted() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF5689FF),
        shape: RoundedRectangleBorder(
          borderRadius:
            BorderRadius.circular(20),
        )),
       onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeLayout())); },
      child: const Padding(
        padding: EdgeInsets.all(15.0),
        child: Text('Get Started',
          style: TextStyle(color: Colors.white, fontSize: 20)),
      )
      );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            displayTitle(),

            const SizedBox(height: 100),
            btnGetStarted()
          ],
      )
    );
  }

}