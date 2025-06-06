import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/services/match/dto/end_match_request.dart';
import 'package:pickleball_app/core/services/match/dto/get_match_response.dart';
import 'package:pickleball_app/core/services/match/dto/match_request.dart';
import 'package:pickleball_app/core/services/match/dto/match_response.dart';
import 'package:pickleball_app/core/services/match/dto/update_match_request.dart';
import 'package:pickleball_app/core/services/match/dto/update_match_response.dart';
import 'package:pickleball_app/core/services/match/endpoints/endpoints.dart';
import 'package:pickleball_app/core/services/match/interface.dart';

class MatchService implements IMatchService {
  MatchService();

  @override
  Future<List<Match>> getAllMatches() async {
    try {
      final response = await globalApiService.get(Endpoint.getAllMatch);
      final listMatch = response['data'] as List;
      final matchInfo = listMatch.map((json) => Match.fromJson(json)).toList();
      return matchInfo;
    } catch (e) {
      throw Exception("Failed to fetch matches");
    }
  }

  @override
  Future<List<Match>> getAllMatchesPublic() async {
    try {
      final response = await globalApiService.get(Endpoint.getMatchPublic);
      final listMatch = response['data'] as List;
      final matchInfo = listMatch.map((json) => Match.fromJson(json)).toList();
      return matchInfo;
    } catch (e) {
      throw Exception("Failed to fetch matches");
    }
  }

  @override
  Future<GetMatchResponse> getMatchById(int id) async {
    try {
      final response =
          await globalApiService.get('${Endpoint.getMatchById}/$id');
      return GetMatchResponse.fromJson(response);
    } catch (e) {
      throw Exception("Failed to fetch match details");
    }
  }

  @override
  Future<CreateMatchResponse> createMatch(CreateMatchRequest request) async {
    try {
      final response =
          await globalApiService.post(Endpoint.createMatch, request.toJson());
      return CreateMatchResponse.fromJson(response['data']);
    } catch (e) {
      print(e);
      throw Exception("Failed to create match details $e");
    }
  }

  @override
  Future<void> deleteMatch(int id) async {
    try {
      await globalApiService.delete('${Endpoint.getMatchById}/$id');
    } catch (e) {
      throw Exception("Failed to delete match");
    }
  }

  @override
  Future<bool> joinMatch(int matchId, int userJoinId) async {
    try {
      final response = await globalApiService.post(Endpoint.joinMatch, {
        'matchId': matchId,
        'userJoinId': userJoinId,
      });
      print(response);
      return response['data'];
    } catch (e) {
      throw Exception("Failed to join match");
    }
  }

  @override
  Future<UpdateMatchResponse> updateMatchById(
      int id, UpdateMatchRequest request) async {
    try {
      final response = await globalApiService.patch(
          '${Endpoint.updateMatch}/$id', request.toJson());
      return UpdateMatchResponse.fromJson(response['data']);
    } catch (e) {
      throw Exception("Failed to update match details");
    }
  }

  @override
  Future<bool> endMatch(EndMatchRequest request) async {
    try {
      final response =
          await globalApiService.post(Endpoint.endMatch, request.toJson());
      return response['data'];
    } catch (e) {
      throw Exception("Failed to end match");
    }
  }

  @override
  Future<List<Match>> getMatchesByUserId(int userId) async {
    try {
      final response = await globalApiService.get('${Endpoint.getMatchByUid}/$userId');
      final listMatch = response['data'] as List;
      final matchInfo = listMatch.map((json) => Match.fromJson(json)).toList();
      return matchInfo;
    } catch (e) {
      throw Exception("Failed to fetch matches by user ID");
    }
  }
}
