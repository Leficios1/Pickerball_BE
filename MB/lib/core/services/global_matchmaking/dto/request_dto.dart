class GlobalMatchmakingRequest {
  final int playerId;
  final String matchType;
  final String matchFormat;
  final int preferredOpponentMinRanking;
  final int preferredOpponentMaxRanking;
  final bool allowCrossLevel;

  GlobalMatchmakingRequest({
    required this.playerId,
    required this.matchType,
    required this.matchFormat,
    required this.preferredOpponentMinRanking,
    required this.preferredOpponentMaxRanking,
    required this.allowCrossLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'matchType': matchType,
      'matchFormat': matchFormat,
      'preferredOpponentMinRanking': preferredOpponentMinRanking,
      'preferredOpponentMaxRanking': preferredOpponentMaxRanking,
      'allowCrossLevel': allowCrossLevel,
    };
  }
}
