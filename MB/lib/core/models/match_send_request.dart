class MatchesSendRequest {
  int id;
  int matchingId;
  int playerRequestId;
  int playerRecieveId;
  int status;
  DateTime createAt;
  DateTime lastUpdatedAt;

  MatchesSendRequest({
    required this.id,
    required this.matchingId,
    required this.playerRequestId,
    required this.playerRecieveId,
    required this.status,
    required this.createAt,
    required this.lastUpdatedAt,
  });

  factory MatchesSendRequest.fromJson(Map<String, dynamic> json) {
    return MatchesSendRequest(
      id: json['id'] as int,
      matchingId: json['matchingId'] as int,
      playerRequestId: json['playerRequestId'] as int,
      playerRecieveId: json['playerRecieveId'] as int,
      status: json['status'] as int,
      createAt: DateTime.parse(json['createdAt'] as String),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matchingId': matchingId,
      'playerRequestId': playerRequestId,
      'playerRecieveId': playerRecieveId,
      'status': status,
      'createdAt': createAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }
}
