abstract class VolunteerState {}

class VolunteerInitial extends VolunteerState {}

class VolunteerRegistering extends VolunteerState {}

class VolunteerRegistered extends VolunteerState {}

class VolunteerRegisterFailed extends VolunteerState {
  final String error;

  VolunteerRegisterFailed(this.error);
}
