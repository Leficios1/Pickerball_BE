import 'package:pickleball_app/core/models/match.dart';
import 'package:pickleball_app/core/services/match/dto/end_match_request.dart';
import 'package:pickleball_app/core/services/match/dto/get_match_response.dart';
import 'package:pickleball_app/core/services/match/dto/match_request.dart';
import 'package:pickleball_app/core/services/match/dto/match_response.dart';
import 'package:pickleball_app/core/services/match/dto/update_match_request.dart';
import 'package:pickleball_app/core/services/match/dto/update_match_response.dart';

abstract class IMatchService {
  Future<List<Match>> getAllMatches();

  Future<GetMatchResponse> getMatchById(int id);

  Future<CreateMatchResponse> createMatch(CreateMatchRequest request);

  Future<void> deleteMatch(int id);

  Future<bool> joinMatch(int matchId, int userJoinId);

  Future<List<Match>> getAllMatchesPublic();

  Future<UpdateMatchResponse> updateMatchById(
      int id, UpdateMatchRequest request);

  Future<bool> endMatch(EndMatchRequest request);

  Future<List<Match>> getMatchesByUserId(int userId);
}
