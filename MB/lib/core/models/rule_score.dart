class RulesScores {
  final int id;
  final int minDifference;
  final int maxDifference;
  final int winnerGain;
  final int loseGain;
  final DateTime createAt;
  final DateTime updateAt;

  RulesScores({
    required this.id,
    required this.minDifference,
    required this.maxDifference,
    required this.winnerGain,
    required this.loseGain,
    required this.createAt,
    required this.updateAt,
  });

  factory RulesScores.fromJson(Map<String, dynamic> json) {
    return RulesScores(
      id: json['id'] as int,
      minDifference: json['minDifference'] as int,
      maxDifference: json['maxDifference'] as int,
      winnerGain: json['winnerGain'] as int,
      loseGain: json['loseGain'] as int,
      createAt: DateTime.parse(json['createAt'] as String),
      updateAt: DateTime.parse(json['updateAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'minDifference': minDifference,
      'maxDifference': maxDifference,
      'winnerGain': winnerGain,
      'loseGain': loseGain,
      'createAt': createAt.toIso8601String(),
      'updateAt': updateAt.toIso8601String(),
    };
  }
}
