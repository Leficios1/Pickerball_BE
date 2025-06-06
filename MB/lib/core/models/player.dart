class Player {
  String province;
  String city;
  int totalMatch;
  int totalWins;
  int rankingPoint;
  int experienceLevel;
  DateTime joinedAt;

  Player({
    required this.province,
    required this.city,
    required this.totalMatch,
    required this.totalWins,
    required this.rankingPoint,
    required this.experienceLevel,
    required this.joinedAt,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      province: json['province'] as String,
      city: json['city'] as String,
      totalMatch: json['totalMatch'] as int,
      totalWins: json['totalWins'] as int,
      rankingPoint: json['rankingPoint'] as int,
      experienceLevel: json['experienceLevel'] as int,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'province': province,
      'city': city,
      'totalMatch': totalMatch,
      'totalWins': totalWins,
      'rankingPoint': rankingPoint,
      'experienceLevel': experienceLevel,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }
}
