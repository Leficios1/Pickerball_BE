import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/models/rankings_tournament.dart';

abstract class IRankingService {
  Future<List<Rankings>> getRankings();
  Future<List<RankingsTournament>> getRankingsByTournamentId(int tournamentId);
}
