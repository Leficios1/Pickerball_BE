import 'package:pickleball_app/core/services/match/dto/get_match_response.dart';

class MatchSendRequestResponse {
  final String requestPlayerName;
  final String createAt;
  final MatchData matchData;
  final String avatarUrl;
  final int requestId;

  MatchSendRequestResponse({
    required this.requestPlayerName,
    required this.createAt,
    required this.matchData,
    required this.avatarUrl,
    required this.requestId,
  });

  factory MatchSendRequestResponse.fromJson(Map<String, dynamic> json) {
    return MatchSendRequestResponse(
      requestPlayerName: json['requestPlayerName'],
      createAt: json['createAt'],
      matchData: MatchData.fromJson(json['matchData']),
      avatarUrl: json['avatarUrl'],
      requestId: json['requestId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestPlayerName': requestPlayerName,
      'createAt': createAt,
      'matchData': matchData.toJson(),
      'avatarUrl': avatarUrl,
      'requestId': requestId,
    };
  }
}
