import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/features/setting/bloc/friend/friend_event.dart';
import 'package:pickleball_app/features/setting/bloc/friend/friend_state.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  AppBloc appBloc;

  FriendBloc({required this.appBloc}) : super(FriendInitial()) {
    on<LoadFriends>(_onLoadFriends);
    on<RemoveFriend>(_onRemoveFriend);
  }

  Future<void> _onLoadFriends(
      LoadFriends event, Emitter<FriendState> emit) async {
    emit(FriendLoading());
    try {
      final appState = appBloc.state;
      final List<Map<String, dynamic>> friends = [];
      if (appState is AppAuthenticatedPlayer ||
          appState is AppAuthenticatedSponsor) {
        final response = await globalFriendService
            .getFriendById((appState as dynamic).userInfo.id);
        final user = await globalUserService
            .getUserById((appState as dynamic).userInfo.id);
        for (var friend in response) {
          final friendUser =
              await globalUserService.getUserById(friend.userFriendId!);
          friends.add({
            'displayName': '${friendUser.firstName}, ${friendUser.lastName}',
            'email': friendUser.email,
            'avatar': friendUser.avatarUrl,
            'friendId': friendUser.id,
            'gender': friendUser.gender,
            'rank': friendUser.userDetails!.experienceLevel
          });
        }
        emit(FriendLoaded(friends, user));
      } else {
        emit(FriendError('User is not authenticated'));
      }
    } catch (e) {
      emit(FriendError('Failed to load friends'));
    }
  }

  Future<void> _onRemoveFriend(
      RemoveFriend event, Emitter<FriendState> emit) async {
    emit(FriendLoading());
    try {
      final appState = appBloc.state;
      if (appState is AppAuthenticatedPlayer) {
        final friend = await globalFriendService.removeFriend(
            appState.userInfo.id, event.friendId);
        emit(FriendRemoved(friend));
      } else {
        emit(FriendError('User is not authenticated'));
      }
    } catch (e) {
      emit(FriendError('Failed to remove friend'));
    }
  }
}
