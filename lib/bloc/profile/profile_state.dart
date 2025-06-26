part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final String username;
  final int points;
  final List<VolunteerActivity> activityList;
  final String contactNumber;
  final String email;
  final String password;
  final String cfmPassword;

  const ProfileState({
    required this.username,
    required this.points,
    required this.activityList,
    required this.contactNumber,
    required this.email,
    required this.password,
    required this.cfmPassword,
  });

  ProfileState copyWith({
    String? username,
    int? points,
    List<VolunteerActivity>? activityList,
    String? contactNumber,
    String? email,
    String? password,
    String? cfmPassword,
  }) {
    return ProfileState(
      username: username ?? this.username,
      points: points ?? this.points,
      activityList: activityList ?? this.activityList,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      cfmPassword: cfmPassword ?? this.cfmPassword,
    );
  }

  @override
  List<Object?> get props => [
    username,
    points,
    activityList,
    contactNumber,
    email,
    password,
    cfmPassword,
  ];
}
