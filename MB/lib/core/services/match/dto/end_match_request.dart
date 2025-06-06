class EndMatchRequest {
  final int matchId;
  final int team1Score;
  final int team2Score;
  final String? urlMatch;
  final String? log;

  EndMatchRequest({
    required this.matchId,
    required this.team1Score,
    required this.team2Score,
    this.urlMatch,
    this.log,
  });

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'team1Score': team1Score,
      'team2Score': team2Score,
      if (urlMatch != null) 'urlMatch': urlMatch,
      if (log != null) 'log': log,
    };
  }

  factory EndMatchRequest.fromJson(Map<String, dynamic> json) {
    return EndMatchRequest(
      matchId: json['matchId'] as int,
      team1Score: json['team1Score'] as int,
      team2Score: json['team2Score'] as int,
      urlMatch: json['urlMatch'] as String?,
      log: json['log'] as String?,
    );
  }
}
