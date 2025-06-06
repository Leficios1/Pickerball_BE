import 'package:flutter/material.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/services/match/dto/end_match_request.dart';
import 'package:pickleball_app/core/services/match/dto/get_match_response.dart';
import 'package:pickleball_app/core/services/match/dto/update_match_request.dart';

abstract class MatchEvent {}

class LoadMatch extends MatchEvent {}

class SelectMatch extends MatchEvent {
  final int match;

  SelectMatch(this.match);
}

class CheckUserPermission extends MatchEvent {
  final int userId;
  final MatchData match;

  CheckUserPermission({required this.userId, required this.match});
}

class JoinMatch extends MatchEvent {
  final int matchId;
  final BuildContext context;

  JoinMatch({required this.matchId, required this.context});
}

class UpdateMatch extends MatchEvent {
  final int matchId;
  final UpdateMatchRequest request;

  UpdateMatch({required this.matchId, required this.request});
}

class StartMatch extends MatchEvent {
  final int matchId;

  StartMatch({required this.matchId});
}

class EndMatch extends MatchEvent {
  EndMatchRequest request;

  EndMatch({required this.request});
}

class RefreshMatchStatus extends MatchEvent {
  final int matchId;
  final int? lastKnownStatus;

  RefreshMatchStatus({required this.matchId, this.lastKnownStatus});
}
