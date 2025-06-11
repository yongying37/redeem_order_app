part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final String username;
  final int points;
  final List<VolunteerActivity> activityList;
  final String phoneNumber;
  final String email;
  final String password;

  const ProfileState({
    required this.username,
    required this.points,
    required this.activityList,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });

  // Start of hardcoded codes to show how UI looks like
  factory ProfileState.initial() {
    return ProfileState(
      username: 'John Doe',
      points: 5200,
      activityList: [
        VolunteerActivity(
          title: "Volunteer Activity 1",
          location: "Heartbeat @ Bedok",
          dateTime: "10 June 2025, 8 am",
          points: "10 points",
        ),
        VolunteerActivity(
          title: "Volunteer Activity 2",
          location: "Our Tampines Hub",
          dateTime: "30 June 2025, 10 am",
          points: "10 points",
        ),
      ],
      phoneNumber: "98765432",
      email: "john@example.com",
      password: "**********",
    );
  }

  ProfileState copyWith ({
    String? username,
    int? points,
    List<VolunteerActivity>? activityList,
    String? phoneNumber,
    String? email,
    String? password,
  }) {
    return ProfileState(
        username: username ?? this.username,
        points: points ?? this.points,
        activityList: activityList ?? this.activityList,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        password: password ?? this.password);
  }

  @override
  List<Object?> get props => [username, activityList, points, phoneNumber, email, password];

}