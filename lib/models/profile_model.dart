class UserProfile {
  final String username;
  final String contactNumber;
  final String email;
  final String password;
  final int points;

  UserProfile({
    required this.username,
    required this.contactNumber,
    required this.email,
    required this.password,
    required this.points,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['account_user_name'],
      contactNumber: json['account_user_contact_number'] ?? '',
      email: json['account_user_email'],
      password: '********',
      points: json['account_user_total_points'],
    );
  }
}
