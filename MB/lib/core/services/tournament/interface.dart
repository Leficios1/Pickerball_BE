import 'package:pickleball_app/core/services/tournament/dto/create_tournament_request.dart';
import 'package:pickleball_app/core/services/tournament/dto/donate_request.dart';
import 'package:pickleball_app/core/services/tournament/dto/get_all_tournament_response.dart';
import 'package:pickleball_app/core/services/tournament/dto/sponsor_response.dart';

import '../../models/models.dart';

abstract class ITournamentService {
  Future<Tournament> getTournamentById(int tournamentId);

  Future<GetAllTournamentResponse> getAllTournaments();

  Future<void> updateTournament(Tournament tournament);

  Future<Tournament> createTournament(CreateTournamentRequest request);

  Future<GetAllTournamentResponse> getAllTournamentsByPlayerId(int playerId);

  Future<GetAllTournamentResponse> getAllTournamentsBySponsorId(int sponsorId);

  Future<List<SponsorResponse>> getAllSponsorByTournamentId(int tournamentId);

  Future<List<Match>> getAllMatchesByTournamentId(int tournamentId);

  Future<int> getGetNumberPlayerByTournamentId(int tournamentId);

  Future<bool> DonateToTournament(DonateRequest request);

  Future<GetAllTournamentResponse> getTournamentRequestByUid(int uid);
}
