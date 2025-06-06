import 'package:pickleball_app/core/models/models.dart';

class GetMatchResponse {
  final MatchData data;

  GetMatchResponse({
    required this.data,
  });

  factory GetMatchResponse.fromJson(Map<String, dynamic> json) {
    return GetMatchResponse(
      data: MatchData.fromJson(json['data']),
    );
  }
}

class MatchData {
  final int id;
  final String title;
  final String description;
  final DateTime matchDate;
  final int? venueId;
  final int status;
  final int matchCategory;
  final int matchFormat;
  final int winScore;
  final int roomOwner;
  final bool isPublic;
  final int? refereeId;
  final int? team1Score;
  final int? team2Score;
  final List<Team> teams;

  MatchData({
    required this.id,
    required this.title,
    required this.description,
    required this.matchDate,
    this.venueId,
    required this.status,
    required this.matchCategory,
    required this.matchFormat,
    required this.winScore,
    required this.roomOwner,
    required this.isPublic,
    this.refereeId,
    required this.teams,
    this.team1Score,
    this.team2Score,
  });

  factory MatchData.fromJson(Map<String, dynamic> json) {
    return MatchData(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      matchDate: DateTime.parse(json['matchDate']),
      venueId: json['venueId'],
      status: json['status'],
      matchCategory: json['matchCategory'],
      matchFormat: json['matchFormat'],
      winScore: json['winScore'],
      roomOwner: json['roomOwner'],
      isPublic: json['isPublic'],
      refereeId: json['refereeId'],
      team1Score: json['team1Score'] as int?,
      team2Score: json['team2Score'] as int?,
      teams:
          (json['teams'] as List?)?.map((e) => Team.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'matchDate': matchDate.toIso8601String(),
      'venueId': venueId,
      'status': status,
      'matchCategory': matchCategory,
      'matchFormat': matchFormat,
      'winScore': winScore,
      'roomOwner': roomOwner,
      'isPublic': isPublic,
      'refereeId': refereeId,
      if (team1Score != null) 'team1Score': team1Score,
      if (team2Score != null) 'team2Score': team2Score,
      'teams': teams.map((e) => e.toJson()).toList(),
    };
  }
}
