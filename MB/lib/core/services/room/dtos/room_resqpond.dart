import 'package:pickleball_app/core/models/simple_data.dart';

class RoomResponse {
  final String message;
  final Room data;

  RoomResponse({
    required this.message,
    required this.data,
  });

  factory RoomResponse.fromJson(Map<String, dynamic> json) {
    return RoomResponse(
      message: json['message'] ?? '',
      data: Room.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}
