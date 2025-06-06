import 'package:pickleball_app/core/services/match_send_request/dto/accept_request_dto.dart';
import 'package:pickleball_app/core/services/match_send_request/dto/create_request.dart';
import 'package:pickleball_app/core/services/match_send_request/dto/response.dart';

abstract class IMatchSendRequestService {
  Future<List<MatchSendRequestResponse>> getByReceviedId(int receviedId);

  Future<List<MatchSendRequestResponse>> getByRequestId(int requestId);

  Future<List<MatchSendRequestResponse>> getSendRequestById(int id);

  Future<MatchSendRequestResponse> createSendRequest(
      CreateMatchSendRequest request);

  Future<MatchSendRequestResponse> acceptRequest(AcceptRequestDTO request);
}
