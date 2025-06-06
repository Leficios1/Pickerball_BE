class CreateMatchSendRequest {
  final int matchingId;
  final int playerRequestId;
  final int playerRecieveId;

  CreateMatchSendRequest({
    required this.matchingId,
    required this.playerRequestId,
    required this.playerRecieveId,
  });

  Map<String, dynamic> toJson() {
    return {
      'matchingId': matchingId,
      'playerRequestId': playerRequestId,
      'playerRecieveId': playerRecieveId,
    };
  }
}
