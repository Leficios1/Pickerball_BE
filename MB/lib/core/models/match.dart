class Match {
  final int id;
  final String title;
  final String description;
  final DateTime matchDate;
  final DateTime? createdAt;
  final int? venueId;
  final int status;
  final int matchCategory;
  final int matchFormat;
  final int winScore;
  final int? team1Score;
  final int? team2Score;
  final bool isPublic;
  final int roomOwner;
  final int? refereeId;
  late String? refereeName;
  late String? venue;

  Match({
    required this.id,
    required this.title,
    required this.description,
    required this.matchDate,
    this.createdAt,
    this.venueId,
    required this.status,
    required this.matchCategory,
    required this.matchFormat,
    required this.winScore,
    this.team1Score,
    this.team2Score,
    required this.isPublic,
    required this.roomOwner,
    this.refereeId,
    this.refereeName,
    this.venue,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      matchDate: DateTime.parse(json['matchDate']),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      venueId: json['venueId'] as int?,
      status: json['status'],
      matchCategory: json['matchCategory'],
      matchFormat: json['matchFormat'],
      winScore: json['winScore'],
      team1Score: json['team1Score'] as int?,
      team2Score: json['team2Score'] as int?,
      isPublic: json['isPublic'],
      roomOwner: json['roomOwner'],
      refereeId: json['refereeId'] as int?,
      refereeName: json['refereeName'],
      venue: json['venue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'matchDate': matchDate.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (venueId != null) 'venueId': venueId,
      'status': status,
      'matchCategory': matchCategory,
      'matchFormat': matchFormat,
      'winScore': winScore,
      if (team1Score != null) 'team1Score': team1Score,
      if (team2Score != null) 'team2Score': team2Score,
      'isPublic': isPublic,
      'roomOwner': roomOwner,
      if (refereeId != null) 'refereeId': refereeId,
      if (refereeName != null) 'refereeName': refereeName,
      if (venue != null) 'venue': venue,
    };
  }
}
