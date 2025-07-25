class UserProfile {
  final int accountUserId;
  final String username;
  final String contactNumber;
  final String email;
  final String password;
  final int points;
  final int redeemedPoints;

  UserProfile({
    required this.accountUserId,
    required this.username,
    required this.contactNumber,
    required this.email,
    required this.password,
    required this.points,
    required this.redeemedPoints,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      accountUserId: json['account_user_id'],
      username: json['account_user_name'],
      contactNumber: json['account_user_contact_number'] ?? '',
      email: json['account_user_email'],
      password: '********',
      points: json['account_user_total_points'],
      redeemedPoints: json['account_user_redeemed_points'],
    );
  }
}
