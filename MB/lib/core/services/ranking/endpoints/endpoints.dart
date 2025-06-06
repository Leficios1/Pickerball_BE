class Endpoints {
  static const String getRanking = '/api/Ranking/LeaderBoard';
  static String getRankingByTournamentId(int tournamentId) =>
      '/api/Ranking/LeaderBoardTourament/$tournamentId';
}
