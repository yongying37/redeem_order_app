class VolunteerOrganization {
  final String id;
  final String name;
  final String imgUrl;
  final String email;

  VolunteerOrganization({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.email,
  });

  factory VolunteerOrganization.fromJson(Map<String, dynamic> json) {
    return VolunteerOrganization(
        id: json['org_id']?.toString() ?? '',
        name: json['org_name']?.toString() ?? '',
        imgUrl: json['org_img_url']?.toString() ?? '',
        email: json['org_email']?.toString() ?? '',
    );
  }
}