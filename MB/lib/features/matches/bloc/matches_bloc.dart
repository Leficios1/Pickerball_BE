import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/features/match/bloc/match_bloc.dart';
import 'package:pickleball_app/features/matches/bloc/matches_event.dart';
import 'package:pickleball_app/features/matches/bloc/matches_state.dart';

import '../../match/bloc/match_state.dart';

class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  final AppBloc appBloc;
  final MatchBloc matchBloc;

  MatchesBloc({required this.appBloc, required this.matchBloc})
      : super(MatchesInitial()) {
    on<LoadAllMatches>(_onLoadAllMatches);
    on<LoadMyMatches>(_onLoadMyMatches);
  }

  Future<void> _onLoadAllMatches(
      LoadAllMatches event, Emitter<MatchesState> emit) async {
    if (state is MatchDetailLoaded) {
      return;  // Skip changing the state
    }
    emit(MatchesLoading());
    try {
      final matches = await globalMatchService.getAllMatchesPublic();

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

      emit(MatchesLoaded(matches));
    } catch (e) {
      emit(MatchesError('Failed to load matches'));
    }
  }

  Future<void> _onLoadMyMatches(
      LoadMyMatches event, Emitter<MatchesState> emit) async {
    if (state is MatchDetailLoaded) {
      return;  // Skip changing the state
    }
    emit(MatchesLoading());
    try {
      final appState = appBloc.state;
      int? userId;
      if (appState is AppAuthenticatedPlayer) {
        userId = appState.userInfo.id;
      }
      if(appState is AppAuthenticatedSponsor) {
        userId = appState.userInfo.id;
      }
      if (userId == null) {
        emit(MatchesError('User not authenticated'));
        return;
      }
      final matches = await globalMatchService.getMatchesByUserId(userId);
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

      emit(MyMatchesLoaded(matches));
    } catch (e) {
      emit(MatchesError('Failed to load your matches'));
    }
  }
}