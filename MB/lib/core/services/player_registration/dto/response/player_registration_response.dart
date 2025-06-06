class PlayerRegistrationResponse {
  final int id;
  final int playerId;
  final int tournamentId;
  final DateTime registeredAt;
  final int isApproved;
  final int? partnerId;

  PlayerRegistrationResponse({
    required this.id,
    required this.playerId,
    required this.tournamentId,
    required this.registeredAt,
    required this.isApproved,
    this.partnerId,
  });

  factory PlayerRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return PlayerRegistrationResponse(
      id: json['id'],
      playerId: json['playerId'],
      tournamentId: json['tournamentId'],
      registeredAt: DateTime.parse(json['registeredAt']),
      isApproved: json['isApproved'],
      partnerId: json['partnerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'tournamentId': tournamentId,
      'registeredAt': registeredAt.toIso8601String(),
      'isApproved': isApproved,
      'partnerId': partnerId,
    };
  }
}
