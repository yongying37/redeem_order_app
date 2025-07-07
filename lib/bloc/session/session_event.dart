part of 'session_bloc.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object> get props => [];
}

class SetUserId extends SessionEvent {
  final int userId;
  const SetUserId(this.userId);

  @override
  List<Object> get props => [userId];
}

class ClearSession extends SessionEvent {}

class Logout extends SessionEvent {}
