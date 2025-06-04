import 'package:flutter/material.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({super.key});

  final List<Map<String, String>> stalls = const [
    {'image': 'assets/images/drinks.png', 'name': 'Drinks'},
    {'image': 'assets/images/waffles.png', 'name': 'Waffle & Fruits'},
    {'image': 'assets/images/chicken_rice.png', 'name': 'Chicken rice'},
    {'image': 'assets/images/western.png', 'name': 'Western'},
    {'image': 'assets/images/japanese.png', 'name': 'Japanese'},
    {'image': 'assets/images/ban_mian.png', 'name': 'Ban Mian Fish soup'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                'Available Stalls',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: stalls.length,
              separatorBuilder: (context, index) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final stall = stalls[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                          stall['image']!,
                          width: 100, // increased width
                          height: 75,  // increased height
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          stall['name']!,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
