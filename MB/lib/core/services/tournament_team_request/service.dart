import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pickleball_app/core/constants/app_constants.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/services/tournament_team_request/dto/get_registration_response.dart';
import 'package:pickleball_app/core/services/tournament_team_request/dto/get_status_join.dart';
import 'package:pickleball_app/core/services/tournament_team_request/dto/tournament_team_response.dart';
import 'package:pickleball_app/core/services/tournament_team_request/endpoints/endpoints.dart';
import 'package:pickleball_app/core/services/tournament_team_request/interface.dart';

class TournamentTeamService implements ITournamentTeamService {
  @override
  Future<String> respondToTeamRequest(int requestId, bool isAccept) async {
    try {
      final url = Uri.parse(
          '${AppConstants.apiBaseUrl}${Endpoints.respondToTeamRequest}$requestId');
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode(isAccept);

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        return 'Request successfully processed';
      } else {
        throw Exception(
            'Failed to respond to team request with status: ${response.statusCode}');
      }
    } on SocketException {
      return Future.error('Network error: Please check your connection');
    } catch (e) {
      print('An error occurred: $e');
      return Future.error('An error occurred while responding to team request');
    }
  }

  @override
  Future<List<TournamentTeamResponse>> getTeamRequestByRequestUserId(
      int userId) async {
    try {
      final response = await globalApiService.get(
        '${Endpoints.getTeamRequestByRequestUserId}/$userId',
      );
      return (response['data'] as List)
          .map((json) => TournamentTeamResponse.fromJson(json))
          .toList();
    } on SocketException {
      return Future.error('Network error: Please check your connection');
    } catch (e) {
      print('An error occurred: $e');
      return Future.error(
          'An error occurred while fetching team requests by request user ID');
    }
  }

  @override
  Future<GetRegistrationResponse> getRegistrationId(
      int userId, int tournamentId) async {
    try {
      final response = await globalApiService.get(
        '${Endpoints.getRegistrationId}/$userId/$tournamentId',
      );
      return GetRegistrationResponse.fromJson(response['data']);
    } on HttpException catch (e) {
      print('HttpException occurred: $e');
      return GetRegistrationResponse();
    } catch (e) {
      print('An unexpected error occurred: $e');
      return GetRegistrationResponse();
    }
  }

  @override
  Future<GetStatusJoin> getStatusJoin(int userId, int tournamentId) async {
    try {
      final response = await globalApiService.get(
        '${Endpoints.getStatusJoin}/$userId/$tournamentId',
      );
      return GetStatusJoin.fromJson(response['data']);
    } on HttpException catch (e) {
      print('HttpException occurred: $e');
      return GetStatusJoin();
    } catch (e) {
      print('An unexpected error occurred: $e');
      return GetStatusJoin();
    }
  }

  @override
  Future<TournamentTeamResponse> getTeamRequestByReceiveUserId(
      int userId) async {
    try {
      final response = await globalApiService.get(
        '${Endpoints.getTeamRequestByReceiveUserId}/$userId',
      );
      final List<dynamic> responseData = response['data'];
      return TournamentTeamResponse.fromJson(responseData[0]);
    } on SocketException {
      return Future.error('Network error: Please check your connection');
    } catch (e) {
      print('An error occurred: $e');
      return Future.error(
          'An error occurred while fetching team requests by receive user ID');
    }
  }
}
