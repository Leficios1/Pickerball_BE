class GetRegistrationResponse {
  final int? id;
  final int? playerId;
  final int? tournamentId;
  final DateTime? registeredAt;
  final int? isApproved;
  final int? partnerId;
  final int? requestId;

  GetRegistrationResponse(
      {this.id,
      this.playerId,
      this.tournamentId,
      this.registeredAt,
      this.isApproved,
      this.partnerId,
      this.requestId});

  factory GetRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return GetRegistrationResponse(
      id: json['id'],
      playerId: json['playerId'],
      tournamentId: json['tournamentId'],
      registeredAt: json['registeredAt'] != null
          ? DateTime.parse(json['registeredAt'])
          : null,
      isApproved: json['isApproved'],
      partnerId: json['partnerId'],
      requestId: json['requestId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'tournamentId': tournamentId,
      'registeredAt': registeredAt?.toIso8601String(),
      'isApproved': isApproved,
      'partnerId': partnerId,
      'requestId': requestId,
    };
  }
}
