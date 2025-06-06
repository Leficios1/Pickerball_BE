class PlayerRegistrationRequest {
  final int tournamentId;
  final int playerId;
  final int? partnerId;

  PlayerRegistrationRequest({
    required this.tournamentId,
    required this.playerId,
    this.partnerId,
  });

  factory PlayerRegistrationRequest.fromJson(Map<String, dynamic> json) {
    return PlayerRegistrationRequest(
      tournamentId: json['tournamentId'],
      playerId: json['playerId'],
      partnerId: json['partnerId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'tournamentId': tournamentId,
      'playerId': playerId,
    };
    if (partnerId != null) data['partnerId'] = partnerId;
    return data;
  }
}
