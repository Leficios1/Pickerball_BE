import 'package:equatable/equatable.dart';
import 'package:pickleball_app/core/services/friend/index.dart';

import '../../../../core/models/user.dart';

abstract class FriendState extends Equatable {
  const FriendState();

  @override
  List<Object> get props => [];
}

class FriendInitial extends FriendState {}

class FriendLoading extends FriendState {}

class FriendLoaded extends FriendState {
  final List<Map<String, dynamic>> friends;
  final User user;

  const FriendLoaded(this.friends, this.user);

  @override
  List<Object> get props => [friends];
}

class FriendError extends FriendState {
  final String message;

  const FriendError(this.message);

  @override
  List<Object> get props => [message];
}

class FriendRemoved extends FriendState {
  final FriendResponse friend;

  const FriendRemoved(this.friend);

  @override
  List<Object> get props => [friend];
}
