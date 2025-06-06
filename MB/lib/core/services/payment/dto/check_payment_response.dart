import 'package:pickleball_app/core/services/payment/dto/vnp_response.dart';

class CheckPaymentResponse {
  final String responseCodeMessage;
  final String transactionStatusMessage;
  final VnPayResponse vnPayResponse;
  final int statusCode;

  CheckPaymentResponse({
    required this.responseCodeMessage,
    required this.transactionStatusMessage,
    required this.vnPayResponse,
    required this.statusCode,
  });

  factory CheckPaymentResponse.fromJson(Map<String, dynamic> json) {
    return CheckPaymentResponse(
      responseCodeMessage: json['data']['responseCodeMessage'],
      transactionStatusMessage: json['data']['transactionStatusMessage'],
      vnPayResponse: VnPayResponse.fromJson(json['data']['vnPayResponse']),
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'responseCodeMessage': responseCodeMessage,
      'transactionStatusMessage': transactionStatusMessage,
      'vnPayResponse': vnPayResponse.toJson(),
      'statusCode': statusCode,
    };
  }
}
