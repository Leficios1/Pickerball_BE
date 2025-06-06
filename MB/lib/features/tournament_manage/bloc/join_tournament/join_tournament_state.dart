import 'package:equatable/equatable.dart';

abstract class JoinTournamentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class JoinTournamentInitial extends JoinTournamentState {}

class TournamentJoining extends JoinTournamentState {}

class TournamentJoined extends JoinTournamentState {
  final bool success;
  final String message;

  TournamentJoined(this.success, this.message);

  @override
  List<Object?> get props => [success, message];
}

class JoinTournamentError extends JoinTournamentState {
  final String message;

  JoinTournamentError(this.message);

  @override
  List<Object?> get props => [message];
}
