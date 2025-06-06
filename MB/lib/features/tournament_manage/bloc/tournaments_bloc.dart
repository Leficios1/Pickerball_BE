import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/models/rankings_tournament.dart';
import 'package:pickleball_app/core/services/tournament/dto/get_all_tournament_response.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_event.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_state.dart';

import '../../../core/models/registration_details.dart';

class TournamentBloc extends Bloc<TournamentEvent, TournamentState> {
  final AppBloc appBloc;

  TournamentBloc({required this.appBloc}) : super(TournamentInitial()) {
    on<LoadAllTournaments>(_onLoadAllTournaments);
    on<CheckUserRole>(_onCheckUserRole);
    on<SelectTournament>(_onSelectTournament);
    on<CheckTournamentOwner>(_onCheckTournamentOwner);
    on<DonateForTournament>(_onDonateForTournament);
    on<RequestJoinTournament>(_onRequestJoinTournament);
  }

  Future<void> _onLoadAllTournaments(
      LoadAllTournaments event, Emitter<TournamentState> emit) async {
    emit(TournamentLoading());
    try {
      final response = await globalTournamentService.getAllTournaments();
      final appState = appBloc.state;
      final List<Map<String, dynamic>> numberPlayers = [];
      final List<Map<String, dynamic>> myTournamentNumberPlayers = [];
      final List<Map<String, dynamic>> tournamentRequestsNumberPlayers = [];
      if (appState is AppAuthenticatedPlayer) {
        final myTournaments = await globalTournamentService
            .getAllTournamentsByPlayerId(appState.userInfo.id);
        for (var tournament in myTournaments.data) {
          final numberPlayer = await globalTournamentService
              .getGetNumberPlayerByTournamentId(tournament.id);
          myTournamentNumberPlayers.add({
            'tournamentId': tournament.id,
            'numberPlayer': numberPlayer,
          });
        }
        final filteredTournaments = response.data.where((tournament) =>
        tournament.status != 'Pending' && tournament.status != 'Completed').toList();
        for (var tournament in filteredTournaments) {
          final numberPlayer = await globalTournamentService
              .getGetNumberPlayerByTournamentId(tournament.id);
          numberPlayers.add({
            'tournamentId': tournament.id,
            'numberPlayer': numberPlayer,
          });
        }
        final tournamentRequests =
        await globalTournamentService.getTournamentRequestByUid(
            appState.userInfo.id);
        for (var tournament in tournamentRequests.data) {
          final numberPlayer = await globalTournamentService
              .getGetNumberPlayerByTournamentId(tournament.id);
          tournamentRequestsNumberPlayers.add({
            'tournamentId': tournament.id,
            'numberPlayer': numberPlayer,
          });
        }
        emit(TournamentLoaded(
          allTournaments: filteredTournaments,
          myTournaments: myTournaments.data,
          numberPlayers: numberPlayers,
          myTournamentNumberPlayers: myTournamentNumberPlayers,
          numberPlayersRequest: tournamentRequestsNumberPlayers,
          requestJoinTournaments: tournamentRequests.data
        ));
      } else if (appState is AppAuthenticatedSponsor) {
        final myTournaments = await globalTournamentService
            .getAllTournamentsBySponsorId(appState.userInfo.id);
        for (var tournament in myTournaments.data) {
          final numberPlayer = await globalTournamentService
              .getGetNumberPlayerByTournamentId(tournament.id);
          myTournamentNumberPlayers.add({
            'tournamentId': tournament.id,
            'numberPlayer': numberPlayer,
          });
        }
        final filteredTournaments = response.data.where((tournament) =>
         tournament.status != 'Completed').toList();
        for (var tournament in response.data) {
          final numberPlayer = await globalTournamentService
              .getGetNumberPlayerByTournamentId(tournament.id);
          numberPlayers.add({
            'tournamentId': tournament.id,
            'numberPlayer': numberPlayer,
          });
        }
        emit(TournamentLoaded(
          allTournaments: filteredTournaments,
          myTournaments: myTournaments.data,
          numberPlayers: numberPlayers,
          myTournamentNumberPlayers: myTournamentNumberPlayers,
        ));
      } else {
        emit(TournamentError('User not authenticated'));
      }
    } catch (error) {
      emit(TournamentError(error.toString()));
    }
  }

  Future<void> _onCheckUserRole(
      CheckUserRole event, Emitter<TournamentState> emit) async {
    try {
      final appState = appBloc.state;
      if (appState is AppAuthenticatedPlayer) {
        emit(UserRoleChecked(true, appState.userInfo.id));
      } else if (appState is AppAuthenticatedSponsor) {
        emit(UserRoleChecked(false, appState.userInfo.id));
      } else {
        emit(TournamentError('User not authenticated'));
      }
    } catch (error) {
      emit(TournamentError(error.toString()));
    }
  }

  Future<void> _onSelectTournament(
      SelectTournament event, Emitter<TournamentState> emit) async {
    emit(TournamentDetailLoading());
    try {
      final tournament =
          await globalTournamentService.getTournamentById(event.tournamentId);
      final appState = appBloc.state;
      if (appState is AppAuthenticatedPlayer) {
        add(CheckTournamentOwner(
            tournamentId: event.tournamentId,
            userId: appState.userInfo.id,
            tournament: tournament));
      } else if (appState is AppAuthenticatedSponsor) {
        add(CheckTournamentOwner(
            tournamentId: event.tournamentId,
            userId: appState.userInfo.id,
            tournament: tournament));
      } else {
        emit(TournamentError('User not authenticated'));
      }
    } catch (error) {
      print(error);
      emit(TournamentError('Error loading tournament details'));
    }
  }

  Future<void> _onCheckTournamentOwner(
      CheckTournamentOwner event, Emitter<TournamentState> emit) async {
    try {
      UserRole userRole;
      int? registrationId;
      RegistrationDetails? registrationDetails;
      bool? isJoin;
      bool isOntap = false;
      final appsState = appBloc.state;
      final sponsors = await globalTournamentService
          .getAllSponsorByTournamentId(event.tournament.id);
      if (appsState is AppAuthenticatedPlayer) {
        if (event.tournament.registrationDetails!.any((element) =>
            element.playerId == event.userId ||
            element.partnerId == event.userId)) {
          final status = await globalTournamentTeamService.getStatusJoin(
              event.userId, event.tournament.id);
          registrationId = event.tournament.registrationDetails!
              .firstWhere((element) =>
                  element.playerId == event.userId ||
                  element.partnerId == event.userId)
              .id;
          switch (status.status) {
            case 1:
              if (event.tournament.registrationDetails!
                  .any((element) => element.playerId == event.userId)) {
                userRole = UserRole.playerPayment;
              } else {
                userRole = UserRole.waitingPayment;
              }
              break;
            case 2:
              userRole = UserRole.playerParticipated;
              isOntap = true;
              break;
            case 3:
              userRole = UserRole.playerRejected;
              break;
            case 4:
              userRole = UserRole.playerWaiting;
              break;
            case 5:
              userRole = UserRole.playerEliminated;
              isOntap = true;
              break;
            case 6:
              userRole = UserRole.invitedPlayer;
              registrationDetails = event.tournament.registrationDetails!
                  .firstWhere((element) =>
                      element.playerId == event.userId ||
                      element.partnerId == event.userId);
              break;
            default:
              isJoin = canJoinMatch(appsState.userInfo, event.tournament);
              userRole = UserRole.player;
          }
        } else {
          isJoin = canJoinMatch(appsState.userInfo, event.tournament);
          userRole = UserRole.player;
        }
      } else if (appsState is AppAuthenticatedSponsor) {
        if(event.tournament.organizerId == event.userId){
          userRole = UserRole.sponsorOwner;
          isOntap = true;
        }else{
          if(sponsors.any((element) => element.id == event.userId)){
            isOntap = true;
            userRole = UserRole.sponsor;
          } else {
            isOntap = false;
            userRole = UserRole.sponsor;
          }
        }


      } else {
        emit(TournamentError('User not authenticated'));
        return;
      }
      final matches = await globalTournamentService
          .getAllMatchesByTournamentId(event.tournament.id);
      for (var match in matches) {
        if (match.venueId != null) {
          final venue = await globalVenueService.getVenueById(match.venueId!);
          match.venue = venue.name;
        }
        if (match.refereeId != null) {
          final referee = await globalUserService.getUserById(match.refereeId!);
          match.refereeName =
          '${referee.firstName}, ${referee.lastName} ${referee.secondName ?? ''}';
        }
      }
      final numberPlayer = await globalTournamentService
          .getGetNumberPlayerByTournamentId(event.tournament.id);
      List<RankingsTournament> ranking = [];
      ranking = await globalRankingService
          .getRankingsByTournamentId(event.tournament.id);
      emit(TournamentDetailLoaded(
        tournament: event.tournament,
        userRole: userRole,
        players: event.tournament.registrationDetails
            ?.where((element) => element.isApproved == 2)
            .toList(),
        sponsors: sponsors,
        referees: [],
        matches: matches,
        history: [],
        registrationId: registrationId,
        registrationDetails: registrationDetails,
        numberOfPlayers: numberPlayer,
        isJoin: isJoin,
        rankings: ranking,
        isOnTap: isOntap,
      ));
    } catch (error) {
      emit(TournamentError('Error checking tournament owner'));
    }
  }

  Future<void> _onDonateForTournament(
      DonateForTournament event, Emitter<TournamentState> emit) async {
    emit(DonateForTournamentLoading());
    try {
      emit(DonateForTournamentLoaded(tournament: event.tournament));
    } catch (error) {
      emit(TournamentError(error.toString()));
    }
  }

  Future<void> _onRequestJoinTournament(
      RequestJoinTournament event, Emitter<TournamentState> emit) async {
    try {
      final appsState = appBloc.state;
      if (appsState is AppAuthenticatedPlayer) {
        final teamRequestId = await globalTournamentTeamService
            .getRegistrationId(appsState.userInfo.id, event.tournamentId);
        debugPrint(
            'Team Request ID: ${teamRequestId.requestId}, Status: ${event.status}');
        await globalTournamentTeamService.respondToTeamRequest(
            teamRequestId.requestId!, event.status);

        add(SelectTournament(event.tournamentId));
      }
    } catch (error) {
      emit(TournamentError('Error processing join request'));
    }
  }

}
bool canJoinMatch(User player, Tournament tournament) {

  if (player.userDetails!.experienceLevel < int.parse(tournament.isMinRanking!) ||
      player.userDetails!.experienceLevel > int.parse(tournament.isMaxRanking!)) {
    return false;
  }
  if(tournament.isMinRanking ==null|| tournament.isMaxRanking ==null || (
      player.userDetails!.experienceLevel >= int.parse(tournament.isMinRanking!) &&
          player.userDetails!.experienceLevel <= int.parse(tournament.isMaxRanking!)) ){
    switch (tournament.type){
      case 'SinglesFemale':
        return player.gender == Gender.female.label;
      case 'SinglesMale':
        return player.gender == Gender.male.label;
      case 'DoublesMale':
        return player.gender == Gender.male.label;
      case 'DoublesFemale':
        return player.gender == Gender.female.label;
      case 'DoublesMix':
        return true;
      default:
        return false;
    }
  }
  return false;
}
