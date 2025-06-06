import 'package:equatable/equatable.dart';

abstract class CreateTournamentState extends Equatable {
  const CreateTournamentState();

  @override
  List<Object> get props => [];
}

class CreateTournamentInitial extends CreateTournamentState {}

class CreateTournamentLoading extends CreateTournamentState {}

class CreateTournamentSuccess extends CreateTournamentState {}

class CreateTournamentFailure extends CreateTournamentState {
  final String error;

  const CreateTournamentFailure(this.error);

  @override
  List<Object> get props => [error];
}
