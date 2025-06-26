part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

class LoadProfile extends ProfileEvent {
  final String userId;
  const LoadProfile(this.userId);
}

class UpdateProfile extends ProfileEvent {
  final String username;
  final String password;
  final String cfmPassword;
  final String email;
  final String contactNumber;

  const UpdateProfile(
    this.username,
    this.password,
    this.cfmPassword,
    this.email,
    this.contactNumber,
  );
}