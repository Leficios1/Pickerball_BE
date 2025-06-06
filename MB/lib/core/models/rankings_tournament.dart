class RankingsTournament {
  final int userId;
  final String fullName;
  final String avatar;
  final int rankingPoint;
  final int experienceLevel;
  final int totalMatch;
  final int totalWins;
  final int point;
  final int position;
  final double? percentOfPrize;
  final double? prize;

  RankingsTournament({
    required this.userId,
    required this.fullName,
    required this.avatar,
    required this.rankingPoint,
    required this.experienceLevel,
    required this.totalMatch,
    required this.totalWins,
    this.point = 0,
    this.position = 0,
    this.percentOfPrize,
    this.prize,
  });

  factory RankingsTournament.fromJson(Map<String, dynamic> json) {
    return RankingsTournament(
      userId: json['userId'] ?? 0,
      fullName: json['fullName'] ?? '',
      avatar: json['avatar'] ?? '',
      rankingPoint: json['rankingPoint'] ?? 0,
      experienceLevel: json['exeprienceLevel'] ?? 0,
      totalMatch: json['totalMatch'] ?? 0,
      totalWins: json['totalWins'] ?? 0,
      point: json['point'] ?? 0,
      position: json['position'] ?? 0,
      percentOfPrize: json['percentOfPrize'] != null ? (json['percentOfPrize']).toDouble() : null,
      prize: json['prize'] != null ? (json['prize']).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'fullName': fullName,
    'avatar': avatar,
    'rankingPoint': rankingPoint,
    'exeprienceLevel': experienceLevel,
    'totalMatch': totalMatch,
    'totalWins': totalWins,
    'point': point,
    'position': position,
    'percentOfPrize': percentOfPrize,
    'prize': prize,
  };
}
