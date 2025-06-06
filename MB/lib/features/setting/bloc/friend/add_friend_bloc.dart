import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/features/setting/bloc/friend/add_friend_event.dart';
import 'package:pickleball_app/features/setting/bloc/friend/add_friend_state.dart';

class AddFriendBloc extends Bloc<AddFriendEvent, AddFriendState> {
  AppBloc appBloc;

  AddFriendBloc({required this.appBloc}) : super(AddFriendInitial()) {
    on<LoadAllPlayers>(_onLoadAllPlayers);
    on<AddFriendEv>(_onAddFriend);
    on<LoadFriendRequests>(_onLoadFriendRequests);
  }

  Future<void> _onLoadAllPlayers(
      LoadAllPlayers event, Emitter<AddFriendState> emit) async {
    emit(AddFriendLoading());
    try {
      final appState = appBloc.state;
      if (appState is AppAuthenticatedPlayer ||
          appState is AppAuthenticatedSponsor) {
        final id = (appState as dynamic).userInfo.id;
        final response = await globalUserService.getAllUsersNotFriend(id);
        List<Map<String, dynamic>> players = [];
        for (var player in response.data) {
          players.add({
            'displayName': '${player.firstName}, ${player.lastName}',
            'email': player.email,
            'avatar': player.avatarUrl,
            'playerId': player.id,
          });
        }
        emit(AllPlayersLoaded(players));
      }

    } catch (e) {
      emit(AddFriendError('Failed to load all players'));
    }
  }

  Future<void> _onAddFriend(
      AddFriendEv event, Emitter<AddFriendState> emit) async {
    emit(AddFriendLoading());
    try {
      final appState = appBloc.state;
      if (appState is AppAuthenticatedPlayer) {
        final friend = await globalFriendService.addFriend(
            appState.userInfo.id, event.friendId);
        emit(FriendAdded());
        add(LoadAllPlayers());
      }
    } catch (e) {
      emit(AddFriendError('Failed to add friend'));
    }
  }

  Future<void> _onLoadFriendRequests(
      LoadFriendRequests event, Emitter<AddFriendState> emit) async {
    emit(AddFriendLoading());
    try {
      final appState = appBloc.state;
      if (appState is AppAuthenticatedPlayer) {
        final friendRequests =
            await globalFriendService.getFriendsRequest(appState.userInfo.id);
        emit(FriendRequestsLoaded(friendRequests));
      }
    } catch (e) {
      emit(AddFriendError('Failed to get friend requests'));
    }
  }
}
