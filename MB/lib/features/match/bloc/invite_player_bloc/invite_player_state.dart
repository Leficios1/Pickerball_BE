import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/services/match/dto/get_match_response.dart';

import '../../../../core/services/friend/dto/friend_response.dart';

abstract class InvitePlayerState {}

class InvitePlayerInitial extends InvitePlayerState {}

class InvitePlayerLoading extends InvitePlayerState {}

class FriendsLoaded extends InvitePlayerState {
  final List<User>? friends;
  final List<User>? users;

  FriendsLoaded(this.friends, this.users);
}

class MatchPlayerAdded extends InvitePlayerState {
  final MatchData match;

  MatchPlayerAdded(this.match);
}

class InvitePlayerError extends InvitePlayerState {
  final String message;

  InvitePlayerError(this.message);
}
