import 'package:pickleball_app/core/models/models.dart';

class UserResponse {
  final String message;
  final List<User> data;

  UserResponse({required this.message, required this.data});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>)
          .map((item) => User.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((user) => user.toJson()).toList(),
    };
  }
}
