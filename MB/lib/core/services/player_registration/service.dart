import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/errors/error_handler.dart';
import 'package:pickleball_app/core/services/player_registration/dto/request/player_registration_request.dart';
import 'package:pickleball_app/core/services/player_registration/dto/response/player_registration_response.dart';
import 'package:pickleball_app/core/services/player_registration/endpoints/endpoints.dart';
import 'package:pickleball_app/core/services/player_registration/interface.dart';

class PlayerRegistrationService implements IPlayerRegistrationService {
  PlayerRegistrationService();

  @override
  Future<PlayerRegistrationResponse> createRegistration(
      PlayerRegistrationRequest request) async {
    try {
      final response = await globalApiService.post(
          Endpoints.createRegistration, request.toJson());
      PlayerRegistrationResponse playerRegistrationResponse =
          PlayerRegistrationResponse.fromJson(response['data']);
      return playerRegistrationResponse;
    } catch (e) {
      print('Error creating registration: $e');
      throw ErrorHandler.handleApiError(e, 'en');
    }
  }

  @override
  Future<PlayerRegistrationResponse> getRegistrationById(int id) async {
    try {
      final response =
          await globalApiService.get('${Endpoints.getRegistrationById}/$id');
      PlayerRegistrationResponse playerRegistrationResponse =
          PlayerRegistrationResponse.fromJson(response['data']);
      return playerRegistrationResponse;
    } catch (e) {
      throw ErrorHandler.handleApiError(e, 'en');
    }
  }

  @override
  Future<List<PlayerRegistrationResponse>> getRegistrationByTournamentId(
      int tournamentId) async {
    try {
      final response = await globalApiService
          .get('${Endpoints.getRegistrationByTournamentId}/$tournamentId');
      List<dynamic> data = response['data'];
      List<PlayerRegistrationResponse> playerRegistrations = data
          .map((item) => PlayerRegistrationResponse.fromJson(item))
          .toList();
      return playerRegistrations;
    } catch (e) {
      throw ErrorHandler.handleApiError(e, 'en');
    }
  }
}
