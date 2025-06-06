class TournamentTeamResponse {
  final int? id;
  final int? registrationId;
  final int? requesterId;
  final int? partnerId;
  final int? status;
  final DateTime? createdAt;

  TournamentTeamResponse({
    this.id,
    this.registrationId,
    this.requesterId,
    this.partnerId,
    this.status,
    this.createdAt,
  });

  factory TournamentTeamResponse.fromJson(Map<String, dynamic> json) {
    return TournamentTeamResponse(
      id: json['id'],
      registrationId: json['registrationId'],
      requesterId: json['requesterId'],
      partnerId: json['partnerId'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registrationId': registrationId,
      'requesterId': requesterId,
      'partnerId': partnerId,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
