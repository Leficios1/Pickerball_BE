class UpdateMatchResponse {
  final int id;
  final String title;
  final String description;
  final DateTime matchDate;
  final DateTime createAt;
  final int? venueId;
  final int status;
  final int matchCategory;
  final int matchFormat;
  final int winScore;
  final int roomOwner;
  final int? team1Score;
  final int? team2Score;
  final bool isPublic;
  final int? refereeId;
  final List<TeamResponse> teamResponse;

  UpdateMatchResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.matchDate,
    required this.createAt,
    this.venueId,
    required this.status,
    required this.matchCategory,
    required this.matchFormat,
    required this.winScore,
    required this.roomOwner,
    this.team1Score,
    this.team2Score,
    required this.isPublic,
    this.refereeId,
    required this.teamResponse,
  });

  factory UpdateMatchResponse.fromJson(Map<String, dynamic> json) {
    return UpdateMatchResponse(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      matchDate: DateTime.parse(json['matchDate']),
      createAt: DateTime.parse(json['createAt']),
      venueId: json['venueId'],
      status: json['status'],
      matchCategory: json['matchCategory'],
      matchFormat: json['matchFormat'],
      winScore: json['winScore'],
      roomOwner: json['roomOwner'],
      team1Score: json['team1Score'],
      team2Score: json['team2Score'],
      isPublic: json['isPublic'],
      refereeId: json['refereeId'],
      teamResponse: (json['teamResponse'] as List?)
              ?.map((team) => TeamResponse.fromJson(team))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'matchDate': matchDate.toIso8601String(),
      'createAt': createAt.toIso8601String(),
      'venueId': venueId,
      'status': status,
      'matchCategory': matchCategory,
      'matchFormat': matchFormat,
      'winScore': winScore,
      'roomOwner': roomOwner,
      'team1Score': team1Score,
      'team2Score': team2Score,
      'isPublic': isPublic,
      'refereeId': refereeId,
      'teamResponse': teamResponse.map((team) => team.toJson()).toList(),
    };
  }
}

class TeamResponse {
  final int id;
  final String name;
  final int captainId;
  final int matchingId;
  final List<Member> members;

  TeamResponse({
    required this.id,
    required this.name,
    required this.captainId,
    required this.matchingId,
    required this.members,
  });

  factory TeamResponse.fromJson(Map<String, dynamic> json) {
    return TeamResponse(
      id: json['id'],
      name: json['name'],
      captainId: json['captainId'],
      matchingId: json['matchingId'],
      members: (json['members'] as List)
          .map((member) => Member.fromJson(member))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'captainId': captainId,
      'matchingId': matchingId,
      'members': members.map((member) => member.toJson()).toList(),
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
