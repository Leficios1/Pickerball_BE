class TournamentMatch {
  final int id;
  final int tournamentId;
  final int matchesId;
  final DateTime createAt;

  TournamentMatch({
    required this.id,
    required this.tournamentId,
    required this.matchesId,
    required this.createAt,
  });

  factory TournamentMatch.fromJson(Map<String, dynamic> json) {
    return TournamentMatch(
      id: json['id'] as int,
      tournamentId: json['tournamentId'] as int,
      matchesId: json['matchesId'] as int,
      createAt: DateTime.parse(json['createAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tournamentId': tournamentId,
      'matchesId': matchesId,
      'createAt': createAt.toIso8601String(),
    };
  }
}
