class Achievement {
  final int id;
  final int userId;
  final String title;
  final String description;
  final DateTime awardedAt;

  Achievement({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.awardedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      awardedAt: DateTime.parse(json['awardedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'awardedAt': awardedAt.toIso8601String(),
    };
  }
}
