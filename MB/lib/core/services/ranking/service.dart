import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/errors/error_handler.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/models/rankings_tournament.dart';
import 'package:pickleball_app/core/services/ranking/endpoints/endpoints.dart';
import 'package:pickleball_app/core/services/ranking/interface.dart';

class RankingService implements IRankingService {
  RankingService();

  @override
  Future<List<Rankings>> getRankings() async {
    try {
      final response = await globalApiService.get(Endpoints.getRanking);
      return response['data']
          .map<Rankings>((item) => Rankings.fromJson(item))
          .toList()
          .cast<Rankings>();
    } catch (error) {
      throw ErrorHandler.handleApiError(error);
    }
  }

  @override
  Future<List<RankingsTournament>> getRankingsByTournamentId(int tournamentId) async {
    try {
      final response = await globalApiService.get(
        Endpoints.getRankingByTournamentId(tournamentId),
      );
      return response['data']
          .map<RankingsTournament>((item) => RankingsTournament.fromJson(item))
          .toList()
          .cast<RankingsTournament>();
    } catch (error) {
      throw ErrorHandler.handleApiError(error);
    }
  }
}
