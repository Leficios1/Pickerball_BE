class Endpoints {
  static const String createTournament = '/api/Tourament/Create';
  static const String getAllTournaments = '/api/Tourament/GetAllTournament';
  static const String getTournamentById = '/api/Tourament/GetTournamentById';
  static const String getAllTournamentsByPlayerId =
      '/api/Tourament/GetTouramentByPlayerId';
  static const String updateTournament = '/api/Tourament/UpdateTournament';
  static const String getAllTournamentsBySponsorId =
      '/api/Tourament/GetAllTouramentBySponnerId';
  static const String getAllSponsorByTournamentId =
      '/api/Tourament/GetAllSponnerByTouramentId';
  static const String getAllMatchesByTournamentId =
      '/api/Match/GetMatchByTouramentId';

  static const String getGetNumberPlayerByTournamentId =
      "/api/PlayerRegistration/CountJoinTourament";

  static const String getTournamentRequestByUid = '/api/Tourament/GetTournamentRequest';
}
