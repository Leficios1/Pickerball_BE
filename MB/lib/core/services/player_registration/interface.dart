import 'package:pickleball_app/core/services/player_registration/dto/request/player_registration_request.dart';
import 'package:pickleball_app/core/services/player_registration/dto/response/player_registration_response.dart';

abstract class IPlayerRegistrationService {
  Future<PlayerRegistrationResponse> createRegistration(
      PlayerRegistrationRequest request);

  Future<PlayerRegistrationResponse> getRegistrationById(int id);

  Future<List<PlayerRegistrationResponse>> getRegistrationByTournamentId(
      int tournamentId);
}
