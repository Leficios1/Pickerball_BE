import 'package:equatable/equatable.dart';

abstract class AddFriendEvent extends Equatable {
  const AddFriendEvent();

  @override
  List<Object> get props => [];
}

class LoadAllPlayers extends AddFriendEvent {}

class AddFriendEv extends AddFriendEvent {
  final int friendId;

  const AddFriendEv({required this.friendId});

  @override
  List<Object> get props => [friendId];
}

class LoadFriendRequests extends AddFriendEvent {}
