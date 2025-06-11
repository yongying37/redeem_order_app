part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String username;
  final String password;
  final String email;
  final String phoneNumber;

  const UpdateProfile(
    this.username,
    this.password,
    this.email,
    this.phoneNumber,
  );
}