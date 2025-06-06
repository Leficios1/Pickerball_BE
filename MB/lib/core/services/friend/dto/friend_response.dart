class FriendResponse {
  final int id;
  final int user1Id;
  final int user2Id;
  final int? userFriendId;
  final String? userFriendName;
  final String? userFriendAvatar;
  final int status;
  final DateTime createdAt;

  FriendResponse({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    this.userFriendId,
    this.userFriendName,
    this.userFriendAvatar,
    required this.status,
    required this.createdAt,
  });

  factory FriendResponse.fromJson(Map<String, dynamic> json) {
    return FriendResponse(
      id: json['id'],
      user1Id: json['user1Id'],
      user2Id: json['user2Id'],
      userFriendId: json['userFriendId'],
      userFriendName: json['userFriendName'],
      userFriendAvatar: json['userFriendAvatar'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'user1Id': user1Id,
      'user2Id': user2Id,
      'userFriendId': userFriendId,
      'userFriendName': userFriendName,
      'userFriendAvatar': userFriendAvatar,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
