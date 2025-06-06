import 'package:pickleball_app/core/services/tournament_team_request/dto/get_registration_response.dart';
import 'package:pickleball_app/core/services/tournament_team_request/dto/get_status_join.dart';
import 'package:pickleball_app/core/services/tournament_team_request/dto/tournament_team_response.dart';

abstract class ITournamentTeamService {
  Future<String> respondToTeamRequest(int requestId, bool isAccept);

  Future<List<TournamentTeamResponse>> getTeamRequestByRequestUserId(
      int userId);

  Future<GetStatusJoin> getStatusJoin(int userId, int tournamentId);

  Future<GetRegistrationResponse> getRegistrationId(
      int userId, int tournamentId);

  Future<TournamentTeamResponse> getTeamRequestByReceiveUserId(int userId);
}
