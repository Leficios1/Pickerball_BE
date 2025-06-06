class User {
  final String id;
  final String username;
  final String email;
  final int role;
  final bool isBanned;
  final String displayName;
  final String avatarUrl;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.isBanned,
    required this.displayName,
    required this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      isBanned: json['is_banned'],
      displayName: json['display_name'],
      avatarUrl: json['avatar_url'],
    );
  }
}

class Room {
  final String id;
  final int team1Score;
  final int team2Score;
  final bool confirmed;
  final String player1Id;
  late final String title;
  late final String location;
  late final String notes;
  final bool isDoubles;
  final String matchType;
  late final DateTime scheduledAt;
  final String status;
  final String? player2Id;
  final String? player3Id;
  final String? player4Id;
  final String? winnerTeam;
  final String? tournamentId;

  Room({
    required this.id,
    required this.team1Score,
    required this.team2Score,
    required this.confirmed,
    required this.player1Id,
    required this.title,
    required this.location,
    required this.notes,
    required this.isDoubles,
    required this.matchType,
    required this.scheduledAt,
    required this.status,
    this.player2Id,
    this.player3Id,
    this.player4Id,
    this.winnerTeam,
    this.tournamentId,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      team1Score: json['team1_score'],
      team2Score: json['team2_score'],
      confirmed: json['confirmed'],
      player1Id: json['player1_id'],
      title: json['title'],
      location: json['location'],
      notes: json['notes'],
      isDoubles: json['is_doubles'],
      matchType: json['match_type'],
      scheduledAt: DateTime.parse(json['scheduled_at']),
      status: json['status'],
      player2Id: json['player2_id'],
      player3Id: json['player3_id'],
      player4Id: json['player4_id'],
      winnerTeam: json['winner_team'],
      tournamentId: json['tournament_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team1_score': team1Score,
      'team2_score': team2Score,
      'confirmed': confirmed,
      'player1_id': player1Id,
      'title': title,
      'location': location,
      'notes': notes,
      'is_doubles': isDoubles,
      'match_type': matchType,
      'scheduled_at': scheduledAt.toIso8601String(),
      'status': status,
      'player2_id': player2Id,
      'player3_id': player3Id,
      'player4_id': player4Id,
      'winner_team': winnerTeam,
      'tournament_id': tournamentId,
    };
  }
}

class UserRank {
  final String userId;
  final String displayName;
  final int score;
  final String? avatarUrl;

  UserRank({
    required this.userId,
    required this.displayName,
    required this.score,
    this.avatarUrl,
  });

  factory UserRank.fromJson(Map<String, dynamic> json) {
    return UserRank(
      userId: json['user_id'],
      displayName: json['display_name'],
      score: json['score'],
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'display_name': displayName,
      'score': score,
      'avatar_url': avatarUrl,
    };
  }
}
