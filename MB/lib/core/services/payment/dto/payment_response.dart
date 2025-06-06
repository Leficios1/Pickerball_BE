class PaymentResponse {
  final String data;
  final int statusCode;
  final String message;

  PaymentResponse({
    required this.data,
    required this.statusCode,
    required this.message,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      data: json['data'] ?? '',
      statusCode: json['statusCode'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'statusCode': statusCode,
      'message': message,
    };
  }
}
