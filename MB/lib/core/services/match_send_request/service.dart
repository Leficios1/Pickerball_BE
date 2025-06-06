import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/services/match_send_request/dto/accept_request_dto.dart';
import 'package:pickleball_app/core/services/match_send_request/dto/create_request.dart';
import 'package:pickleball_app/core/services/match_send_request/dto/response.dart';
import 'package:pickleball_app/core/services/match_send_request/endpoints/endpoints.dart';
import 'package:pickleball_app/core/services/match_send_request/interface.dart';

class MatchSendRequestService implements IMatchSendRequestService {
  MatchSendRequestService();

  @override
  Future<List<MatchSendRequestResponse>> getByReceviedId(int receviedId) async {
    final response =
        await globalApiService.get('${Endpoints.getByReceviedId}/$receviedId');
    return (response['data'] as List)
        .map((json) => MatchSendRequestResponse.fromJson(json))
        .toList();
  }

  @override
  Future<List<MatchSendRequestResponse>> getByRequestId(int requestId) async {
    final response =
        await globalApiService.get('${Endpoints.getByRequestId}/$requestId');
    return (response['data'] as List)
        .map((json) => MatchSendRequestResponse.fromJson(json))
        .toList();
  }

  @override
  Future<List<MatchSendRequestResponse>> getSendRequestById(int id) async {
    final response =
        await globalApiService.get('${Endpoints.getSendRequestById}/$id');
    return (response['data'] as List)
        .map((json) => MatchSendRequestResponse.fromJson(json))
        .toList();
  }

  @override
  Future<MatchSendRequestResponse> createSendRequest(
      CreateMatchSendRequest request) async {
    final response = await globalApiService.post(
        Endpoints.createSendRequest, request.toJson());
    return MatchSendRequestResponse.fromJson(response);
  }

  @override
  Future<MatchSendRequestResponse> acceptRequest(AcceptRequestDTO request) async {
    final response = await globalApiService.put(
      Endpoints.acceptRequest,
      request.toJson(),
    );
    return MatchSendRequestResponse.fromJson(response);
  }
}
