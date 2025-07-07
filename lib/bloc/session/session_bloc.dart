import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc() : super(const SessionState(userId: 0)) {
    on<SetUserId>((event, emit) {
      emit(SessionState(userId: event.userId));
    });

    on<ClearSession>((event, emit) {
      emit(const SessionState(userId: 0)); // reset to guest
    });

    on<Logout>((event, emit) {
      emit(const SessionState(userId: 0));
    });
  }
}
