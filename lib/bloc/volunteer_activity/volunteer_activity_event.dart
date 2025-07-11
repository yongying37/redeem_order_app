abstract class VolunteerEvent {}

class RegisterForActivity extends VolunteerEvent {
  final int activityId;
  final int userId;

  RegisterForActivity({required this.activityId, required this.userId});
}
