import 'package:pickleball_app/core/models/models.dart';

class CreateMatchResponse {
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
  final List<Team> teams;

  CreateMatchResponse({
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
  });

  factory CreateMatchResponse.fromJson(Map<String, dynamic> json) {
    return CreateMatchResponse(
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
      teams: (json['teams'] as List)
          .map((teamJson) => Team.fromJson(teamJson))
          .toList(),
    );
  }
}
