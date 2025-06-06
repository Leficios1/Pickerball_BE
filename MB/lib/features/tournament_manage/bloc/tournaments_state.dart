import 'package:equatable/equatable.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/models/rankings_tournament.dart';
import 'package:pickleball_app/core/models/registration_details.dart';
import 'package:pickleball_app/core/services/tournament/dto/sponsor_response.dart';

abstract class TournamentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TournamentInitial extends TournamentState {}

class TournamentLoading extends TournamentState {}

class TournamentLoaded extends TournamentState {
  final List<Tournament> allTournaments;
  final List<Tournament> myTournaments;
  final List<Map<String, dynamic>> numberPlayers;
  final List<Map<String, dynamic>> myTournamentNumberPlayers;
  final List<Tournament>? requestJoinTournaments;
  final List<Map<String, dynamic>>? numberPlayersRequest;

  TournamentLoaded({
    required this.allTournaments,
    required this.myTournaments,
    required this.myTournamentNumberPlayers,
    required this.numberPlayers,
     this.requestJoinTournaments,
     this.numberPlayersRequest,
  });

  @override
  List<Object?> get props => [allTournaments, myTournaments];
}

class TournamentError extends TournamentState {
  final String message;

  TournamentError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserRoleChecked extends TournamentState {
  final bool isPlayer;
  final int userId;

  UserRoleChecked(this.isPlayer, this.userId);

  @override
  List<Object?> get props => [isPlayer, userId];
}

class TournamentDetailLoading extends TournamentState {}

class TournamentDetailLoaded extends TournamentState {
  final Tournament tournament;
  final UserRole userRole;
  final List<RegistrationDetails>? players;
  final List<Map<String, dynamic>>? referees;
  final List<SponsorResponse>? sponsors;
  final List<Match>? matches;
  final List<Map<String, dynamic>>? history;
  final int? registrationId;
  final RegistrationDetails? registrationDetails;
  final int numberOfPlayers;
  final bool? isJoin;
  final List<RankingsTournament>? rankings;
  final bool isOnTap;

  TournamentDetailLoaded(
      {required this.tournament,
      required this.userRole,
      this.players,
      this.referees,
      this.matches,
      this.history,
      this.sponsors,
      this.registrationId,
      this.registrationDetails,
      required this.numberOfPlayers,
      this.rankings,
      this.isJoin,
      required this.isOnTap});

  @override
  List<Object?> get props => [
        tournament,
        userRole,
        players,
        referees,
        matches,
        history,
        sponsors,
        registrationId,
        registrationDetails,
        numberOfPlayers,
        rankings,
        isJoin,
        isOnTap,
      ];
}

class DonateForTournamentLoading extends TournamentState {}

class DonateForTournamentLoaded extends TournamentState {
  final Tournament tournament;

  DonateForTournamentLoaded({required this.tournament});

  @override
  List<Object?> get props => [tournament];
}

class RequestJoinTournamentState extends TournamentState {
  final bool isAccepted;

  RequestJoinTournamentState({required this.isAccepted});

  @override
  List<Object> get props => [isAccepted];
}
