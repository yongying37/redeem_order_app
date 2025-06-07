import 'package:flutter/material.dart';

import '../ordertype_stalls/ordertype_page.dart';

class StallLayout extends StatelessWidget {
  StallLayout({super.key});

  final List<Map<String, String>> stalls = [
    {'name': 'Drinks', 'image': 'assets/images/drinks.jpeg'},
    {'name': 'Waffle & Fruits', 'image': 'assets/images/waffle_fruits.jpeg'},
    {'name': 'Chicken rice', 'image': 'assets/images/chicken_rice.jpeg'},
    {'name': 'Western', 'image': 'assets/images/western.jpeg'},
    {'name': 'Japanese', 'image': 'assets/images/japanese.jpeg'},
    {'name': 'Ban Mian Fish Soup', 'image': 'assets/images/ban_mian.jpeg'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stalls.length,
      itemBuilder: (context, index) {
        final stall = stalls[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: Image.asset(
              stall['image']!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(stall['name']!),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to the DrinksMenuPage if the "Drinks" stall is tapped
              if (stall['name'] == 'Drinks') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderTypesPage(
                    stallName: 'Drinks',
                    supportsDinein: true,
                    supportsTakeaway: true,
                    ),
                  ), // Navigate to Drinks Menu
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${stall['name']} selected')),
                );
              }
            },
          ),
        );
      },
    );
  }
}
