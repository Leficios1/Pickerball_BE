class GlobalMatchmakingResponseDTO {
  final String status;
  final String message;
  final List<dynamic> data;

  GlobalMatchmakingResponseDTO({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GlobalMatchmakingResponseDTO.fromJson(Map<String, dynamic> json) {
    return GlobalMatchmakingResponseDTO(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}
