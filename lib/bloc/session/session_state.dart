part of 'session_bloc.dart';

class SessionState extends Equatable {
  final int userId;
  const SessionState({required this.userId});

  @override
  List<Object> get props => [userId];
}
