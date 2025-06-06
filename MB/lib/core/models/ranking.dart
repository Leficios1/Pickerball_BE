class Rankings {
  final int userId;
  final String fullName;
  final String avatar;
  final int rankingPoint;
  final int experienceLevel;
  final int totalMatch;
  final int totalWins;

  Rankings({
    required this.userId,
    required this.fullName,
    required this.avatar,
    required this.rankingPoint,
    required this.experienceLevel,
    required this.totalMatch,
    required this.totalWins,
  });

  factory Rankings.fromJson(Map<String, dynamic> json) {
    return Rankings(
      userId: json['userId'] ?? 0,
      fullName: json['fullName'] ?? '',
      avatar: json['avatar'] ?? '',
      rankingPoint: json['rankingPoint'] ?? 0,
      experienceLevel: json['exeprienceLevel'] ?? 0,
      totalMatch: json['totalMatch'] ?? 0,
      totalWins: json['totalWins'] ?? 0,
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
  };
}