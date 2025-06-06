class CreateMatchRequest {
  final String title;
  final String description;
  final DateTime matchDate;
  final int? venueId;
  final int status;
  final int matchCategory;
  final int matchFormat;
  final int winScore;
  final bool isPublic;
  final int roomOnwer;
  final int player1Id;
  final int? player2Id;
  final int? player3Id;
  final int? player4Id;
  final int? refereeId;
  final int? tournamentId;

  CreateMatchRequest({
    required this.title,
    required this.description,
    required this.matchDate,
    this.venueId,
    required this.status,
    required this.matchCategory,
    required this.matchFormat,
    required this.winScore,
    required this.isPublic,
    required this.roomOnwer,
    required this.player1Id,
    this.player2Id,
    this.player3Id,
    this.player4Id,
    this.refereeId,
    this.tournamentId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "title": title,
      "description": description,
      "matchDate": matchDate.toIso8601String(),
      "status": status,
      "matchCategory": matchCategory,
      "matchFormat": matchFormat,
      "winScore": winScore,
      "isPublic": isPublic,
      "roomOnwer": roomOnwer,
      "player1Id": player1Id,
    };
    if (venueId != null) data["venueId"] = venueId;
    if (refereeId != null) data["refereeId"] = refereeId;
    if (player2Id != null) data["player2Id"] = player2Id;
    if (player3Id != null) data["player3Id"] = player3Id;
    if (player4Id != null) data["player4Id"] = player4Id;
    if (tournamentId != null) data["tournamentId"] = tournamentId;

    return data;
  }
}
