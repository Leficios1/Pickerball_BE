import 'dart:convert';

class DonateRequest {
  final String userId;
  final String tourId;
  final double amount;

  DonateRequest({
    required this.userId,
    required this.tourId,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'tourId': tourId,
      'amount': amount,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory DonateRequest.fromJson(Map<String, dynamic> json) {
    return DonateRequest(
      userId: json['userId'] as String,
      tourId: json['tourId'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }
}
