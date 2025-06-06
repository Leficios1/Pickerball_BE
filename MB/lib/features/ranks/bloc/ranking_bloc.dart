import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/services/ranking/interface.dart';
import 'package:pickleball_app/features/ranks/bloc/ranking_event.dart';
import 'package:pickleball_app/features/ranks/bloc/ranking_state.dart';

class RankingBloc extends Bloc<RankingEvent, RankingState> {
  RankingBloc() : super(RankingInitial()) {
    on<LoadRankings>(_onLoadRankings);
  }

  Future<void> _onLoadRankings(
    LoadRankings event,
    Emitter<RankingState> emit,
  ) async {
    emit(RankingLoading());
    try {
      final rankings = await globalRankingService.getRankings();
      emit(RankingLoaded(rankings));
    } catch (error) {
      emit(RankingError(error.toString()));
    }
  }
}
