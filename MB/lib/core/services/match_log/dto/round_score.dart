class RoundScore {
  final int roundNumber;
  final int team1Points;
  final int team2Points;

  RoundScore({
    required this.roundNumber,
    required this.team1Points,
    required this.team2Points,
  });

  @override
  String toString() {
    return 'RoundScore(roundNumber: $roundNumber, team1Points: $team1Points, team2Points: $team2Points)';
  }
}
