import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/bloc/ordertype/ordertype_bloc.dart';
import 'package:redeem_order_app/bloc/session/session_bloc.dart';
import 'package:redeem_order_app/widgets/custom_bottom_nav.dart';
import 'package:redeem_order_app/views/stall/stall_page.dart';
import 'package:redeem_order_app/views/order_history/order_page.dart';
import 'package:redeem_order_app/views/volunteer/volunteer_organization_page.dart';
import 'package:redeem_order_app/views/profile/profile_page.dart';
import 'package:redeem_order_app/views/cart/cart_page.dart';
import 'package:redeem_order_app/views/login/login_page.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _currentIndex = 0;

  void updateCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = context.watch<SessionBloc>().state;
    final userId = sessionState.userId;

    final List<Widget> screens = [
      const HomeContent(),
      const StallPage(),
      userId != 0
          ? OrderPage(userId: userId)
          : Center(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              const TextSpan(text: "Please "),
              TextSpan(
                text: "log in",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
              ),
              const TextSpan(text: " to view orders"),
            ],
          ),
        ),
      ),
      const VolunteerOrganizationPage(),
      userId != 0
          ? ProfilePage(userId: userId)
          : Center(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              const TextSpan(text: "Please "),
              TextSpan(
                text: "log in",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
              ),
              const TextSpan(text: " to view your profile"),
            ],
          ),
        ),
      ),
    ];

    return Scaffold(
      body: SafeArea(child: screens[_currentIndex]),
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
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final _HomeLayoutState homeLayoutState = context.findAncestorStateOfType<_HomeLayoutState>()!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    context.read<OrderTypeBloc>().add(const SelectOrderType('Dine In'));

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(
                          stallName: 'Stall A',
                          supportsDinein: true,
                          supportsTakeaway: true,
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.shopping_cart, size: 28),
                ),
                const SizedBox(width: 16),
                BlocBuilder<SessionBloc, SessionState>(
                  builder: (context, sessionState) {
                    final isLoggedIn = sessionState.userId != 0;

                    return GestureDetector(
                      onTap: () {
                        if (isLoggedIn) {
                          homeLayoutState.updateCurrentIndex(4);
                        }
                        else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        }
                      },
                      child: Icon(isLoggedIn ? Icons.account_circle : Icons.login, size: 28),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 16),

            // Banner with "Order Now" button
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
                      'SIT Earn and Redeem',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        homeLayoutState.updateCurrentIndex(1);
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
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
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
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}