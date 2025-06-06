import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/services/match_send_request/dto/create_request.dart';
import 'package:pickleball_app/core/utils/snackbar_helper.dart';
import 'package:pickleball_app/features/match/bloc/invite_player_bloc/invite_player_event.dart';
import 'package:pickleball_app/features/match/bloc/invite_player_bloc/invite_player_state.dart';

class InvitePlayerBloc extends Bloc<InvitePlayerEvent, InvitePlayerState> {
  AppBloc appBloc;

  InvitePlayerBloc(this.appBloc) : super(InvitePlayerInitial()) {
    on<LoadFriends>(_onLoadFriends);
    on<AddPlayer>(_onAddPlayer);
  }

  Future<void> _onLoadFriends(
      LoadFriends event, Emitter<InvitePlayerState> emit) async {
    try {
      if (event.type == 'Option 1') {
        final appState = appBloc.state;
        final int uid;
        if (appState is AppAuthenticatedPlayer) {
          uid = appState.userInfo.id;
        } else if (appState is AppAuthenticatedSponsor) {
          uid = appState.userInfo.id;
        } else {
          throw Exception('User is not authenticated');
        }
        final friends = await globalFriendService.getFriendById(uid);
        final List<User> users = [];
        for(var friend in friends) {
          final user = await globalUserService.getUserById(friend.userFriendId!);
          users.add(user);
        }
        emit(FriendsLoaded(users, null));
      }
    } catch (e) {
      emit(InvitePlayerError('Failed to load friends'));
    }
  }

  Future<void> _onAddPlayer(
      AddPlayer event, Emitter<InvitePlayerState> emit) async {
    try {
      final appState = appBloc.state;
      final int uid;
      if (appState is AppAuthenticatedPlayer) {
        uid = appState.userInfo.id;
      } else if (appState is AppAuthenticatedSponsor) {
        uid = appState.userInfo.id;
      } else {
        throw Exception('User is not authenticated');
      }
      final CreateMatchSendRequest request = CreateMatchSendRequest(
        matchingId: event.matchId,
        playerRequestId: uid,
        playerRecieveId: event.playerRecieveId,
      );
      final response = await globalMatchSendRequestService.createSendRequest(request);
      debugPrint('Add player response: ${response.toJson()}');
      SnackbarHelper.showSnackBar(response.message);
    } catch (e) {
      SnackbarHelper.showSnackBar('Failed to add player to match');
      emit(InvitePlayerError('Failed to add player to match'));
    }
  }
}
