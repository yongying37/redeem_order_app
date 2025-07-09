import 'package:flutter/material.dart';
import 'package:redeem_order_app/models/volunteer_organization_model.dart';
import 'package:redeem_order_app/services/volunteer_organization_service.dart';
import 'package:redeem_order_app/views/volunteer/volunteer_activity_page.dart';

class VolunteerOrganizationLayout extends StatefulWidget {
  const VolunteerOrganizationLayout({super.key});

  @override
  State<VolunteerOrganizationLayout> createState() => _VolunteerOrganizationLayoutState();
}

class _VolunteerOrganizationLayoutState extends State<VolunteerOrganizationLayout> {
  late Future<List<VolunteerOrganization>> _organizations;

  @override
  void initState() {
    super.initState();
    _organizations = VolunteerOrganizationService.fetchVolunteerOrganizations();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VolunteerOrganization>>(
      future: _organizations,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No volunteer organizations found.'));
        }

        final organizations = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                'Discover Volunteer opportunities',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Below are some organizations where you can volunteer and earn points!\nClick "Learn More" to explore activities that they have.',
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: organizations.length,
                itemBuilder: (context, index) {
                  final org = organizations[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        leading: ClipOval(
                          child: Image.network(
                            org.imgUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.groups),
                          ),
                        ),
                        title: Text(
                          org.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(org.email),
                        trailing: SizedBox(
                          width: 90,
                          height: 32,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VolunteerActivityPage(
                                    organizationId: org.id,
                                    organizationName: org.name,
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              textStyle: const TextStyle(fontSize: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: const BorderSide(color: Colors.black),
                            ),
                            child: const Text("Learn More", style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
