import 'package:flutter/material.dart';
import 'package:redeem_order_app/widgets/custom_bottom_nav.dart';
import 'package:redeem_order_app/views/stall/stall_page.dart';
import 'package:redeem_order_app/views/order_history/order_page.dart';
import 'package:redeem_order_app/views/volunteer/volunteer_page.dart';
import 'package:redeem_order_app/views/profile/profile_page.dart';

import 'package:redeem_order_app/views/cart/cart_page.dart';
import 'package:redeem_order_app/views/order_type/order_type_page.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const StallPage(),
    const OrderPage(),
    const VolunteerPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_currentIndex]),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

// Separate Home tab UI
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Text('5200 pts', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CartPage()),
                        );
                      },
                      child: const Icon(Icons.shopping_cart, size: 28),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Banner with Order Now button
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/canteen.jpg',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Foodgle Hub',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const OrderTypePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                          'Order Now',
                        style: TextStyle(
                          color: Colors.white,
                        )
                      ),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 24),

            Center(
              child: Image.asset(
                'assets/images/reward_flow.jpeg',
                width: 300,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Earn points through volunteering work\n"
                  "Redeem points to enjoy discount during purchase",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 50),

            // NETS info
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // Ensure vertical alignment
                children: [
                  Image.asset(
                    'assets/images/nets_logo.jpeg',
                    height: 70,
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Fast, secure\npayments with QR code",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80), // avoid bottom nav overlap
          ],
        ),
      ),
    );
  }
}
