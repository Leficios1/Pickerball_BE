import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/utils/snackbar_helper.dart';
import 'package:pickleball_app/features/match/bloc/create_match/create_match_event.dart';
import 'package:pickleball_app/features/match/bloc/create_match/create_match_state.dart';
import 'package:pickleball_app/features/match/bloc/match_bloc.dart';
import 'package:pickleball_app/features/match/bloc/match_event.dart';
import 'package:pickleball_app/features/match/bloc/match_state.dart';

class CreateMatchBloc extends Bloc<CreateMatchEvent, CreateMatchState> {
  final MatchBloc matchBloc;

  CreateMatchBloc({required this.matchBloc}) : super(CreateMatchInitial()) {
    on<CreateMatch>(_onCreateMatch);
  }

  Future<void> _onCreateMatch(
      CreateMatch event, Emitter<CreateMatchState> emit) async {
    try {
      emit(CreateMatchLoading());
      final match = await globalMatchService.createMatch(event.match);
      List<Map<String, String?>> players = [];
      for (var team in match.teams) {
        for (var member in team.members) {
          final userInfo = await globalUserService.getUserById(member.playerId);
          final displayName =
              '${userInfo.firstName}, ${userInfo.lastName} ${userInfo.secondName ?? ''}';
          players.add({
            'name': team.name,
            'playerId': member.playerId.toString(),
            'displayName': displayName,
            'avatar': userInfo.avatarUrl,
            'isOwner': (member.playerId == match.roomOwner).toString(),
          });
        }
      }
      final Match matchDetail = Match(
        id: match.id,
        title: match.title,
        description: match.description,
        matchDate: match.matchDate,
        status: match.status,
        matchCategory: match.matchCategory,
        matchFormat: match.matchFormat,
        winScore: match.winScore,
        isPublic: match.isPublic,
        roomOwner: match.roomOwner,
      );
      emit(CreateMatchSuccess(matchDetail));
      matchBloc.add(SelectMatch(matchDetail.id));
      SnackbarHelper.showSnackBar('Match created successfully');

    } catch (e) {
      emit(CreateMatchError('Error creating match'));
    }
  }
}
