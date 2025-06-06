import 'package:pickleball_app/core/models/tournament.dart';

class GetAllTournamentResponse {
  final List<Tournament> data;
  final int statusCode;
  final String message;

  GetAllTournamentResponse({
    required this.data,
    required this.statusCode,
    required this.message,
  });

  factory GetAllTournamentResponse.fromJson(Map<String, dynamic> json) {
    return GetAllTournamentResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => Tournament.fromJson(item))
              .toList() ??
          [],
      statusCode: json['statusCode'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'statusCode': statusCode,
      'message': message,
    };
  }
}
