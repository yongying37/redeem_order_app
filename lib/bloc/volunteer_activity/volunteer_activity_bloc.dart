import 'package:flutter_bloc/flutter_bloc.dart';
import 'volunteer_activity_event.dart';
import 'volunteer_activity_state.dart';
import 'package:redeem_order_app/services/volunteer_activity_service.dart';

class VolunteerBloc extends Bloc<VolunteerEvent, VolunteerState> {
  VolunteerBloc() : super(VolunteerInitial()) {
    on<RegisterForActivity>(_onRegister);
  }

  Future<void> _onRegister(
      RegisterForActivity event,
      Emitter<VolunteerState> emit,
      ) async {
    emit(VolunteerRegistering());
    try {
      final success = await VolunteerActivityService.registerForActivity(
        event.userId,
        event.activityId,
      );
      if (success) {
        emit(VolunteerRegistered());
      } else {
        emit(VolunteerRegisterFailed("Already registered or invalid request."));
      }
    } catch (e) {
      emit(VolunteerRegisterFailed(e.toString()));
    }
  }
}
