import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/volunteer_activity_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(): super(ProfileState.initial()) {
    on<LoadProfile>((event, emit) {
      emit(ProfileState.initial());
    });

    on<UpdateProfile>((event, emit) {
      emit(state.copyWith(
        username: event.username,
        phoneNumber: event.phoneNumber,
        email: event.email,
        password: event.password,
      ));
    });
  }
}