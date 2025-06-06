import 'package:pickleball_app/core/models/models.dart';

class RankResponse {
  final String message;
  final List<Rankings> data;

  RankResponse({required this.message, required this.data});

  factory RankResponse.fromJson(Map<String, dynamic> json) {
    return RankResponse(
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((item) => Rankings.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((rank) => rank.toJson()).toList(),
    };
  }
}
