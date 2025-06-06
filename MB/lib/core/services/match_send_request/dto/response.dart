class MatchSendRequestResponse {
  final String message;
  final Data? data; // Allow null values for dat

  MatchSendRequestResponse({
    required this.message,
    this.data, // Make data optional
  });

  factory MatchSendRequestResponse.fromJson(Map<String, dynamic> json) {
    return MatchSendRequestResponse(
      message: json['message'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null, // Handle null data
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (data != null) 'data': data!.toJson(), // Include data only if it's not null
    };
  }
}

class Data {
  final int id;
  final int matchingId;
  final int playerRequestId;
  final int playerRecieveId;
  final int status;
  final DateTime createAt;
  final DateTime lastUpdatedAt;

  Data({
    required this.id,
    required this.matchingId,
    required this.playerRequestId,
    required this.playerRecieveId,
    required this.status,
    required this.createAt,
    required this.lastUpdatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      matchingId: json['matchingId'],
      playerRequestId: json['playerRequestId'],
      playerRecieveId: json['playerRecieveId'],
      status: json['status'],
      createAt: DateTime.parse(json['createAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matchingId': matchingId,
      'playerRequestId': playerRequestId,
      'playerRecieveId': playerRecieveId,
      'status': status,
      'createAt': createAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }
}
