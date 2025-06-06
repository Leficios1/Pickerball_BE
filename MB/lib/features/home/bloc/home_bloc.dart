import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/services/tournament/dto/get_all_tournament_response.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AppBloc appBloc;

  HomeBloc({required this.appBloc}) : super(HomeInitial()) {
    on<LoadTournaments>(_onLoadTournaments);
  }

  Future<void> _onLoadTournaments(
      LoadTournaments event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final List<Map<String, dynamic>> numberPlayers = [];
      late GetAllTournamentResponse myTournaments;
      final appState = appBloc.state;
      if (appState is AppAuthenticatedPlayer) {
        myTournaments = await globalTournamentService
            .getAllTournamentsByPlayerId(appState.userInfo.id);
        for (var tournament in myTournaments.data) {
          final numberPlayer = await globalTournamentService
              .getGetNumberPlayerByTournamentId(tournament.id);
          numberPlayers.add({
            'tournamentId': tournament.id,
            'numberPlayer': numberPlayer,
          });
        }
      } else if (appState is AppAuthenticatedSponsor) {
        myTournaments = await globalTournamentService
            .getAllTournamentsBySponsorId(appState.userInfo.id);
        for (var tournament in myTournaments.data) {
          final numberPlayer = await globalTournamentService
              .getGetNumberPlayerByTournamentId(tournament.id);
          numberPlayers.add({
            'tournamentId': tournament.id,
            'numberPlayer': numberPlayer,
          });
        }
      }
      emit(HomeLoaded(
          tournaments: myTournaments.data, numberPlayer: numberPlayers));
    } catch (error) {
      emit(HomeError(error.toString()));
    }
  }
}
