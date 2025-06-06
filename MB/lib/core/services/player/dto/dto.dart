class CreatePlayerRequest {
  final int playerId;
  final String province;
  final String city;

  CreatePlayerRequest({
    required this.playerId,
    required this.province,
    required this.city,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'province': province,
      'city': city,
    };
  }
}

class CreatePlayerResponse {
  final String province;
  final String city;
  final DateTime joinedAt;

  CreatePlayerResponse({
    required this.province,
    required this.city,
    required this.joinedAt,
  });

  factory CreatePlayerResponse.fromJson(Map<String, dynamic> json) {
    return CreatePlayerResponse(
      province: json['province'],
      city: json['city'],
      joinedAt: DateTime.parse(json['joinedAt']),
    );
  }
}
