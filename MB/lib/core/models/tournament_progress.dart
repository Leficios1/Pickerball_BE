class TournamentProgress {
  final int id;
  final int tournamentRegistrationId;
  final int roundNumber;
  final bool isEliminated;
  final int wins;
  final int losses;
  final DateTime lastUpdated;

  TournamentProgress({
    required this.id,
    required this.tournamentRegistrationId,
    required this.roundNumber,
    required this.isEliminated,
    required this.wins,
    required this.losses,
    required this.lastUpdated,
  });

  factory TournamentProgress.fromJson(Map<String, dynamic> json) {
    return TournamentProgress(
      id: json['id'] as int,
      tournamentRegistrationId: json['tournamentRegistrationId'] as int,
      roundNumber: json['roundNumber'] as int,
      isEliminated: json['isEliminated'] as bool,
      wins: json['wins'] as int,
      losses: json['losses'] as int,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tournamentRegistrationId': tournamentRegistrationId,
      'roundNumber': roundNumber,
      'isEliminated': isEliminated,
      'wins': wins,
      'losses': losses,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
