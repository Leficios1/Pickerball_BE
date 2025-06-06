class Team {
  final int id;
  final String name;
  final int? captainId;
  final int matchingId;
  final List<Member> members;

  Team({
    required this.id,
    required this.name,
    this.captainId,
    required this.matchingId,
    required this.members,
  });

  int get membersCount => members.length;

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      captainId: json['captainId'],
      matchingId: json['matchingId'],
      members:
          (json['members'] as List?)?.map((e) => Member.fromJson(e)).toList() ??
              [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'captainId': captainId,
      'matchingId': matchingId,
      'members': members.map((e) => e.toJson()).toList(),
    };
  }
}

class Member {
  final int id;
  final int playerId;
  final int teamId;
  final DateTime joinedAt;

  Member({
    required this.id,
    required this.playerId,
    required this.teamId,
    required this.joinedAt,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      playerId: json['playerId'],
      teamId: json['teamId'],
      joinedAt: DateTime.parse(json['joinedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'teamId': teamId,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }
}
