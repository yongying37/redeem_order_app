class UserProfile {
  final String accountUserId;
  final String username;
  final String contactNumber;
  final String email;
  final String password;
  final int points;

  UserProfile({
    required this.accountUserId,
    required this.username,
    required this.contactNumber,
    required this.email,
    required this.password,
    required this.points,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      accountUserId: json['account_user_id'].toString(),
      username: json['account_user_name'],
      contactNumber: json['account_user_contact_number'] ?? '',
      email: json['account_user_email'],
      password: '********',
      points: json['account_user_total_points'],
    );
  }
}
