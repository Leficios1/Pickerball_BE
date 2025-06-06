import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/services/match/dto/update_match_request.dart';
import 'package:pickleball_app/core/services/user/dto/user_response.dart';
import 'package:pickleball_app/core/utils/snackbar_helper.dart';
import 'package:pickleball_app/features/match/bloc/match_event.dart';
import 'package:pickleball_app/features/match/bloc/match_state.dart';
import 'package:pickleball_app/router/router.gr.dart';

import '../../../core/services/venue/dto/venues_response.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  AppBloc appBloc;

  MatchBloc(this.appBloc) : super(MatchInitial()) {
    on<SelectMatch>(_onSelectMatch);
    on<CheckUserPermission>(_onCheckUserPermission);
    on<JoinMatch>(_onJoinMatch);
    on<UpdateMatch>(_onUpdateMatch);
    on<StartMatch>(_onStartMatch);
    on<EndMatch>(_onEndMatch);
    on<RefreshMatchStatus>(_onRefreshMatchStatus);
  }

  Future<void> _onSelectMatch(
      SelectMatch event, Emitter<MatchState> emit) async {
    try {
      final response = await globalMatchService.getMatchById(event.match);
      final appState = appBloc.state;
      int? userId;
      if (appState is AppAuthenticatedPlayer) {
        userId = appState.userInfo.id;
      } else if (appState is AppAuthenticatedSponsor) {
        userId = appState.userInfo.id;
      } else {
        emit(MatchError('Please login to view match details'));
      }
      add(CheckUserPermission(
          userId: userId!, match: response.data));
    } catch (e) {
      emit(MatchError('Error loading match details'));
    }
  }

  void _onCheckUserPermission(
      CheckUserPermission event, Emitter<MatchState> emit) async {
    emit(MatchDetailLoading());
    bool isOwner = false;
    if(event.match.matchCategory==3){
      isOwner= false;
    }else{
      isOwner = event.match.roomOwner == event.userId;
    }
    final List<Map<String, String?>> players = [];

    List<int> playerIds = event.match.teams
        .expand((team) => team.members.map((m) => m.playerId))
        .toList();

    List<User> users = await Future.wait(
        playerIds.map((id) => globalUserService.getUserById(id)));

    final Map<int, User> userMap = {for (var user in users) user.id: user};
    final UserResponse referees = await globalUserService.getAllReferees();
    final List<VenuesResponse> venues = await globalVenueService.getAllVenues();
    for (var teams in event.match.teams) {
      for (var player in teams.members) {
        final user = userMap[player.playerId]!;
        final displayName =
            '${user.firstName}, ${user.lastName} ${user.secondName ?? ''}';

        players.add({
          'name': teams.name,
          'playerId': user.id.toString(),
          'displayName': displayName,
          'email': user.email,
          'avatar': user.avatarUrl,
          'isOwner': (user.id == event.match.roomOwner).toString(),
        });
      }
    }
    emit(MatchDetailLoaded(
        players: players,
        match: event.match,
        isOwner: isOwner,
        matchFormat: event.match.matchFormat,
        venues: venues,
        referees: referees));
  }

  Future<void> _onJoinMatch(JoinMatch event, Emitter<MatchState> emit) async {
    emit(MatchJoining());
    try {
      final appState = appBloc.state;
      if (appState is AppAuthenticatedPlayer) {
        final success = await globalMatchService.joinMatch(
            event.matchId, appState.userInfo.id);
        emit(MatchJoined(success));
        
        if (success) {
          SnackbarHelper.showSnackBar('Joined match successfully');
          try {
            // Fetch match data after navigation
            final match = await globalMatchService.getMatchById(event.matchId);
            
            // Wait a short time to allow UI to stabilize after navigation
            await Future.delayed(Duration(milliseconds: 300));
            
            // Now trigger the match selection
            add(SelectMatch(event.matchId));
          } catch (e) {
            debugPrint('Error getting match details after join: $e');
          }
        } else {
          SnackbarHelper.showSnackBar('Failed to join match');
        }
      } else {
        emit(MatchError('Please login to join match'));
        return;
      }
    } catch (e) {
      emit(MatchError('Error joining match'));
    }
  }

  Future<void> _onUpdateMatch(
      UpdateMatch event, Emitter<MatchState> emit) async {
    emit(MatchDetailLoading());
    try {
      await globalMatchService.updateMatchById(event.matchId, event.request);
      final responseMatch =
          await globalMatchService.getMatchById(event.matchId);

      final appState = appBloc.state;
      if (appState is AppAuthenticatedPlayer) {
        add(CheckUserPermission(
            userId: appState.userInfo.id, match: responseMatch.data));
        SnackbarHelper.showSnackBar('Match updated successfully');
      } else if (appState is AppAuthenticatedSponsor) {
        add(CheckUserPermission(
            userId: appState.userInfo.id, match: responseMatch.data));
        SnackbarHelper.showSnackBar('Match updated successfully');
      } else {
        emit(MatchError('Please login to view match details'));
      }
    } catch (e) {
      emit(MatchError('Failed to update match'));
    }
  }

  Future<void> _onStartMatch(StartMatch event, Emitter<MatchState> emit) async {
    emit(MatchDetailLoading());
    try {
      await globalMatchService.updateMatchById(
          event.matchId, UpdateMatchRequest(status: 2));
      final responseMatch =
          await globalMatchService.getMatchById(event.matchId);
      final appState = appBloc.state;
      if (appState is AppAuthenticatedPlayer) {
        add(CheckUserPermission(
            userId: appState.userInfo.id, match: responseMatch.data));
        SnackbarHelper.showSnackBar('Match started successfully');
      } else if (appState is AppAuthenticatedSponsor) {
        add(CheckUserPermission(
            userId: appState.userInfo.id, match: responseMatch.data));
        SnackbarHelper.showSnackBar('Match started successfully');
      } else {
        emit(MatchError('Please login to view match details'));
      }
    } catch (e) {
      emit(MatchError('Failed to start match'));
    }
  }

  Future<void> _onEndMatch(EndMatch event, Emitter<MatchState> emit) async {
    emit(MatchDetailLoading());
    try {
      final responseMatch = await globalMatchService.endMatch(event.request);
      final response =
          await globalMatchService.getMatchById(event.request.matchId);
      final appState = appBloc.state;
      if (appState is AppAuthenticatedPlayer) {
        if (responseMatch == true) {
          add(CheckUserPermission(
              userId: appState.userInfo.id, match: response.data));
          SnackbarHelper.showSnackBar('End match successfully');
        }
      } else if (appState is AppAuthenticatedSponsor) {
        if (responseMatch == true) {
          add(CheckUserPermission(
              userId: appState.userInfo.id, match: response.data));
          SnackbarHelper.showSnackBar('End match successfully');
        }
      } else {
        emit(MatchError('Please login to view match details'));
      }
    } catch (e) {
      emit(MatchError('End match failed'));
    }
  }

  Future<void> _onRefreshMatchStatus(
      RefreshMatchStatus event, Emitter<MatchState> emit) async {
    try {
      // Don't emit loading state to avoid UI flicker during periodic refreshes
      final response = await globalMatchService.getMatchById(event.matchId);
      
      // Only reload the UI if the status has changed
      if (event.lastKnownStatus != response.data.status) {
        final appState = appBloc.state;
        if (appState is AppAuthenticatedPlayer || appState is AppAuthenticatedSponsor) {
          final userId = appState is AppAuthenticatedPlayer 
              ? appState.userInfo.id 
              : (appState as AppAuthenticatedSponsor).userInfo.id;
              
          add(CheckUserPermission(userId: userId, match: response.data));
        }
      }
    } catch (e) {
      // Silently handle errors during status refresh
      debugPrint('Error refreshing match status: $e');
    }
  }
}
