import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/services/tournament/dto/create_tournament_request.dart';

abstract class TournamentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAllTournaments extends TournamentEvent {}

class CheckUserRole extends TournamentEvent {
  final int userId;

  CheckUserRole(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SelectTournament extends TournamentEvent {
  final int tournamentId;

  SelectTournament(this.tournamentId);

  @override
  List<Object?> get props => [tournamentId];
}

class JoinTournament extends TournamentEvent {
  final int tournamentId;
  final int? partnerId;
  final BuildContext context;

  JoinTournament(
      {required this.tournamentId, required this.context, this.partnerId});

  @override
  List<Object?> get props => [tournamentId, context, partnerId];
}

class PaymentCompleted extends TournamentEvent {
  final int tournamentId;

  PaymentCompleted({required this.tournamentId});

  @override
  List<Object?> get props => [tournamentId];
}

class CheckTournamentOwner extends TournamentEvent {
  final int tournamentId;
  final int userId;
  final Tournament tournament;

  CheckTournamentOwner(
      {required this.tournamentId,
      required this.userId,
      required this.tournament});

  @override
  List<Object?> get props => [tournamentId, userId, tournament];
}

class DonateForTournament extends TournamentEvent {
  final Tournament tournament;
  final BuildContext context;

  DonateForTournament({required this.tournament, required this.context});

  @override
  List<Object?> get props => [tournament];
}

class RequestJoinTournament extends TournamentEvent {
  final int tournamentId;
  final bool status;

  RequestJoinTournament({required this.status, required this.tournamentId});

  @override
  List<Object> get props => [status, tournamentId];
}

class CreateTournament extends TournamentEvent {
  final CreateTournamentRequest tournament;
  final BuildContext context;

  CreateTournament({required this.tournament, required this.context});

  @override
  List<Object?> get props => [tournament, context];
}
