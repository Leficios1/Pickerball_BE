import 'dart:convert';

class JoinTournamentRequest {
  final String userId;
  final String tourId;
  final String registrationId;

  JoinTournamentRequest({
    required this.userId,
    required this.tourId,
    required this.registrationId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'tourId': tourId,
      'registrationId': registrationId,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory JoinTournamentRequest.fromJson(Map<String, dynamic> json) {
    return JoinTournamentRequest(
      userId: json['userId'] as String,
      tourId: json['tourId'] as String,
      registrationId: json['registrationId'] as String,
    );
  }
}
