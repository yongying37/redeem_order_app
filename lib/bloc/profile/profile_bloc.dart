import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:redeem_order_app/models/volunteer_activity_model.dart';
import 'package:redeem_order_app/services/auth_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthService _authService = AuthService();

  ProfileBloc()
      : super(const ProfileState(
    userId: 0,
    username: '',
    points: 0,
    activityList: [],
    contactNumber: '',
    email: '',
    password: '',
    cfmPassword: '',
  )) {
    on<LoadProfile>((event, emit) async {
      try {
        final userProfile = await _authService.getProfile(event.userId);

        if (userProfile != null) {
          emit(ProfileState(
            userId: userProfile.accountUserId,
            username: userProfile.username,
            points: userProfile.points,
            activityList: [],
            contactNumber: userProfile.contactNumber,
            email: userProfile.email,
            password: userProfile.password,
            cfmPassword: userProfile.password,
          ));
        } else {
          print('User profile not found.');
        }
      } catch (e) {
        print("Failed to load profile: $e");
      }
    });

    on<UpdateProfile>((event, emit) {
      emit(state.copyWith(
        username: event.username,
        contactNumber: event.contactNumber,
        email: event.email,
        password: event.password,
        cfmPassword: event.cfmPassword,
      ));
    });

    on<DoNothing>((event, emit) {

    });
  }
}
