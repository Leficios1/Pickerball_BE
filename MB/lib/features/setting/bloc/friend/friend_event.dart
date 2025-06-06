import 'package:equatable/equatable.dart';

abstract class FriendEvent extends Equatable {
  const FriendEvent();

  @override
  List<Object> get props => [];
}

class LoadFriends extends FriendEvent {}

class RemoveFriend extends FriendEvent {
  final int friendId;

  const RemoveFriend(this.friendId);

  @override
  List<Object> get props => [friendId];
}
