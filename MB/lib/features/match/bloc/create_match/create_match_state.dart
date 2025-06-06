import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/services/match/dto/get_match_response.dart';

abstract class CreateMatchState {}

class CreateMatchInitial extends CreateMatchState {}

class CreateMatchLoading extends CreateMatchState {}

class CreateMatchSuccess extends CreateMatchState {
  final Match match;

  CreateMatchSuccess(this.match);
}

class CreateMatchDetailLoaded extends CreateMatchState {
  final MatchData match;
  final bool isOwner;
  final int matchFormat;
  final List<Map<String, String?>> players;

  CreateMatchDetailLoaded({
    required this.match,
    required this.isOwner,
    required this.matchFormat,
    required this.players,
  });
}

class CreateMatchError extends CreateMatchState {
  final String message;

  CreateMatchError(this.message);
}
