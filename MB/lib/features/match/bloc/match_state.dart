import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/services/match/dto/get_match_response.dart';
import 'package:pickleball_app/core/services/user/dto/user_response.dart';
import 'package:pickleball_app/core/services/venue/dto/venues_response.dart';

abstract class MatchState {}

class MatchInitial extends MatchState {}

class MatchLoading extends MatchState {}

class MatchListLoaded extends MatchState {
  final List<Match> matches;

  MatchListLoaded(this.matches);
}

class MatchDetailLoading extends MatchState {}

class MatchDetailLoaded extends MatchState {
  final MatchData match;
  final bool isOwner;
  final int matchFormat;
  final List<Map<String, String?>> players;
  final List<VenuesResponse> venues;
  final UserResponse referees;

  MatchDetailLoaded(
      {required this.match,
      required this.isOwner,
      required this.matchFormat,
      required this.players,
      required this.venues,
      required this.referees});
}

class MatchError extends MatchState {
  final String message;

  MatchError(this.message);
}

class MatchJoining extends MatchState {}

class MatchJoined extends MatchState {
  final bool success;

  MatchJoined(this.success);
}
