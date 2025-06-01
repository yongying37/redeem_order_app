import 'package:flutter/material.dart';

// Temporary placeholder pages for navigation
class ShopsPage extends StatelessWidget {
  const ShopsPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Shops Page'));
}

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Order Page'));
}

class VolunteerPage extends StatelessWidget {
  const VolunteerPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Volunteer Page'));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Profile Page'));
}

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeContent(),
    ShopsPage(),
    OrderPage(),
    VolunteerPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shops'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Order'),
          BottomNavigationBarItem(icon: Icon(Icons.volunteer_activism), label: 'Volunteer'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
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
            // Top bar (points and cart)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: const [
                    Text('5200 pts', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 8),
                    Icon(Icons.shopping_cart, size: 28),
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
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Order Now'),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 24),

            // How it works image
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
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

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
