import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/services/tournament/dto/create_tournament_request.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/create_tournament/create_tournament_event.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/create_tournament/create_tournament_state.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_event.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_state.dart';

class CreateTournamentBloc
    extends Bloc<CreateTournamentEvent, CreateTournamentState> {
  final AppBloc appBloc;
  final TournamentBloc tournamentBloc;

  CreateTournamentBloc({required this.appBloc, required this.tournamentBloc})
      : super(CreateTournamentInitial()) {
    on<CreateTournamentRequestEvent>(_onCreateTournament);
  }

  Future<void> _onCreateTournament(CreateTournamentRequestEvent event,
      Emitter<CreateTournamentState> emit) async {
    emit(CreateTournamentLoading());
    try {
      final appState = appBloc.state;
      if (appState is AppAuthenticatedSponsor) {
        final request = CreateTournamentRequest(
          name: event.createTournamentRequest.name,
          location: event.createTournamentRequest.location,
          maxPlayer: event.createTournamentRequest.maxPlayer,
          description: event.createTournamentRequest.description,
          banner: event.createTournamentRequest.banner,
          note: event.createTournamentRequest.note,
          social: event.createTournamentRequest.social,
          totalPrize: event.createTournamentRequest.totalPrize,
          startDate: event.createTournamentRequest.startDate,
          endDate: event.createTournamentRequest.endDate,
          isFree: event.createTournamentRequest.isFree == true ? false : true,
          type: event.createTournamentRequest.type,
          organizerId: appState.userInfo.id,
          entryFee: event.createTournamentRequest.entryFee,
          isMaxRanking: event.createTournamentRequest.isMaxRanking,
          isMinRanking: event.createTournamentRequest.isMinRanking,
        );
        final response =
            await globalTournamentService.createTournament(request);
        tournamentBloc.add(SelectTournament(response.id));
        if (tournamentBloc is TournamentDetailLoading) {
          emit(CreateTournamentSuccess());
        }
      } else {
        emit(CreateTournamentFailure('User not authenticated'));
      }
    } catch (error) {
      emit(CreateTournamentFailure(error.toString()));
    }
  }
}
