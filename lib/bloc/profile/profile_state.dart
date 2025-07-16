part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final int userId;
  final String username;
  final int points;
  final int redeemedPoints;
  final List<VolunteerActivity> activityList;
  final String contactNumber;
  final String email;
  final String password;
  final String cfmPassword;

  const ProfileState({
    required this.userId,
    required this.username,
    required this.points,
    required this.redeemedPoints,
    required this.activityList,
    required this.contactNumber,
    required this.email,
    required this.password,
    required this.cfmPassword,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      userId: 0,
      username: '',
      points: 0,
      redeemedPoints: 0,
      activityList: [],
      contactNumber: '',
      email: '',
      password: '',
      cfmPassword: '',
    );
  }

  ProfileState copyWith({
    int? userId,
    String? username,
    int? points,
    int? redeemedPoints,
    List<VolunteerActivity>? activityList,
    String? contactNumber,
    String? email,
    String? password,
    String? cfmPassword,
  }) {
    return ProfileState(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      points: points ?? this.points,
      redeemedPoints: redeemedPoints ?? this.redeemedPoints,
      activityList: activityList ?? this.activityList,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      cfmPassword: cfmPassword ?? this.cfmPassword,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    username,
    points,
    redeemedPoints,
    activityList,
    contactNumber,
    email,
    password,
    cfmPassword,
  ];
}
