class AcceptRequestDTO {
  final int requestId;
  final int userAcceptId;
  final int status;

  AcceptRequestDTO({
    required this.requestId,
    required this.userAcceptId,
    required this.status,
  });

  factory AcceptRequestDTO.fromJson(Map<String, dynamic> json) {
    return AcceptRequestDTO(
      requestId: json['requestId'],
      userAcceptId: json['userAcceptId'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'userAcceptId': userAcceptId,
      'status': status,
    };
  }
}
