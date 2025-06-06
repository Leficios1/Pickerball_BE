class TeamMembers {
  final int id;
  final int teamId;
  final int playerId;
  final DateTime joinedAt;

  TeamMembers({
    required this.id,
    required this.teamId,
    required this.playerId,
    required this.joinedAt,
  });

  factory TeamMembers.fromJson(Map<String, dynamic> json) {
    return TeamMembers(
      id: json['id'] as int,
      teamId: json['teamId'] as int,
      playerId: json['playerId'] as int,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teamId': teamId,
      'playerId': playerId,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }
}
