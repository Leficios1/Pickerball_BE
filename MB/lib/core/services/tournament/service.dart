import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/errors/error_handler.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/services/tournament/dto/create_tournament_request.dart';
import 'package:pickleball_app/core/services/tournament/dto/donate_request.dart';
import 'package:pickleball_app/core/services/tournament/dto/get_all_tournament_response.dart';
import 'package:pickleball_app/core/services/tournament/dto/sponsor_response.dart';
import 'package:pickleball_app/core/services/tournament/endpoints/endpoints.dart';
import 'package:pickleball_app/core/services/tournament/interface.dart';

class TournamentService implements ITournamentService {
  TournamentService();

  @override
  Future<Tournament> getTournamentById(int tournamentId) async {
    try {
      final response = await globalApiService
          .get('${Endpoints.getTournamentById}/$tournamentId');
      return Tournament.fromJson(response['data']);
    } catch (error) {
      throw ErrorHandler.handleApiError(error);
    }
  }

  @override
  Future<GetAllTournamentResponse> getAllTournaments() async {
    try {
      final initialResponse = await globalApiService.get(
          '${Endpoints.getAllTournaments}?PageNumber=1&PageSize=10&isOrderbyCreateAt=true');
      final totalPages = initialResponse['totalPages'];
      final List<Tournament> allTournament = [];
      for (int page = 1; page <= totalPages; page++) {
        final response = await globalApiService.get(
            '${Endpoints.getAllTournaments}?PageNumber=$page&PageSize=10&isOrderbyCreateAt=true');
        final data = response['data'] as List;
        final tournaments = data
            .map((tournament) => Tournament.fromJson(tournament))
            .where((tournament) => tournament.isAccept)
            .toList();
        allTournament.addAll(tournaments);
      }
      return GetAllTournamentResponse(
        message: initialResponse['message'],
        data: allTournament,
        statusCode: initialResponse['statusCode'],
      );
    } catch (error) {
      throw ErrorHandler.handleApiError(error);
    }
  }

  @override
  Future<void> updateTournament(Tournament tournament) async {
    try {
      await globalApiService.put(
          '${Endpoints.updateTournament}/${tournament.id}',
          tournament.toJson());
    } catch (error) {
      throw ErrorHandler.handleApiError(error);
    }
  }

  @override
  Future<Tournament> createTournament(CreateTournamentRequest request) async {
    try {
      final response = await globalApiService.post(
          Endpoints.createTournament, request.toJson());
      return Tournament.fromJson(response['data']);
    } catch (error) {
      throw ErrorHandler.handleApiError(error);
    }
  }

  @override
  Future<GetAllTournamentResponse> getAllTournamentsByPlayerId(
      int userId) async {
    try {
      final response = await globalApiService
          .get('${Endpoints.getAllTournamentsByPlayerId}/$userId');
      return GetAllTournamentResponse.fromJson(response);
    } catch (error) {
      throw ErrorHandler.handleApiError(error);
    }
  }

  @override
  Future<bool> DonateToTournament(DonateRequest request) {
    // TODO: implement DonateToTournament
    throw UnimplementedError();
  }

  @override
  Future<GetAllTournamentResponse> getAllTournamentsBySponsorId(
      int sponsorId) async {
    try {
      final response = await globalApiService
          .get('${Endpoints.getAllTournamentsBySponsorId}/$sponsorId');
      return GetAllTournamentResponse.fromJson(response);
    } catch (error) {
      throw ErrorHandler.handleApiError(error);
    }
  }

  @override
  Future<List<SponsorResponse>> getAllSponsorByTournamentId(
      int tournamentId) async {
    try {
      final response = await globalApiService
          .get('${Endpoints.getAllSponsorByTournamentId}/$tournamentId');
      return List<SponsorResponse>.from(
          response['data'].map((x) => SponsorResponse.fromJson(x)));
    } catch (error) {
      throw ErrorHandler.handleApiError(error);
    }
  }

  @override
  Future<List<Match>> getAllMatchesByTournamentId(int tournamentId) async {
    try {
      final response = await globalApiService
          .get('${Endpoints.getAllMatchesByTournamentId}/$tournamentId');
      print(response);
      final listMatch = (response['data'] ?? []) as List;
      final matchInfo = listMatch.map((json) => Match.fromJson(json)).toList();
      return matchInfo;
    } catch (error) {
      throw ErrorHandler.handleApiError(error);
    }
  }

  @override
  Future<int> getGetNumberPlayerByTournamentId(int tournamentId) async {
    try {
      final response = await globalApiService
          .get('${Endpoints.getGetNumberPlayerByTournamentId}/$tournamentId');
      return response['data'];
    } catch (e) {
      throw ErrorHandler.handleApiError(e);
    }
  }

  @override
  Future<GetAllTournamentResponse> getTournamentRequestByUid(
      int uid) async {
    try {
      final response = await globalApiService.get(
          '${Endpoints.getTournamentRequestByUid}/$uid');
      return GetAllTournamentResponse.fromJson(response);
    } catch (error) {
      throw ErrorHandler.handleApiError(error);
    }
  }
}
