class TournamentRegistration {
  final int id;
  final int tournamentId;
  final int playerId;
  final DateTime registeredAt;
  final bool isApproved;

  TournamentRegistration({
    required this.id,
    required this.tournamentId,
    required this.playerId,
    required this.registeredAt,
    required this.isApproved,
  });

  factory TournamentRegistration.fromJson(Map<String, dynamic> json) {
    return TournamentRegistration(
      id: json['id'] as int,
      tournamentId: json['tournamentId'] as int,
      playerId: json['playerId'] as int,
      registeredAt: DateTime.parse(json['registeredAt'] as String),
      isApproved: json['isApproved'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tournamentId': tournamentId,
      'playerId': playerId,
      'registeredAt': registeredAt.toIso8601String(),
      'isApproved': isApproved,
    };
  }
}
