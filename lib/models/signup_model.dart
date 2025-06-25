class SignupRequest {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String contactNumber;
  final String gender;

  SignupRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.contactNumber,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
    'account_user_name': name,
    'account_user_email': email,
    'account_user_password': password,
    'account_user_confirm_password': confirmPassword,
    'account_user_contact_number': contactNumber,
    'account_user_gender': gender,
  };
}
