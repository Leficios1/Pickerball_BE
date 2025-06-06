import 'package:equatable/equatable.dart';
import 'package:pickleball_app/core/services/friend/dto/friend_response.dart';

abstract class AddFriendState extends Equatable {
  const AddFriendState();

  @override
  List<Object> get props => [];
}

class AddFriendInitial extends AddFriendState {}

class AddFriendLoading extends AddFriendState {}

class AllPlayersLoaded extends AddFriendState {
  final List<Map<String, dynamic>> players;

  const AllPlayersLoaded(this.players);

  @override
  List<Object> get props => [players];
}

class FriendAdded extends AddFriendState {
  @override
  List<Object> get props => [];
}

class AddFriendError extends AddFriendState {
  final String message;

  const AddFriendError(this.message);

  @override
  List<Object> get props => [message];
}

class FriendRequestsLoaded extends AddFriendState {
  final List<FriendResponse> friendRequests;

  const FriendRequestsLoaded(this.friendRequests);

  @override
  List<Object> get props => [friendRequests];
}
