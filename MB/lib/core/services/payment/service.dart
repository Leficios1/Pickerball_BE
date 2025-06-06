import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/services/payment/dto/check_payment_response.dart';
import 'package:pickleball_app/core/services/payment/dto/payment_response.dart';
import 'package:pickleball_app/core/services/payment/dto/vnp_response.dart';
import 'package:pickleball_app/core/services/payment/endpoints/endpoints.dart';
import 'package:pickleball_app/core/services/payment/interface.dart';

class PaymentService implements IPaymentService {
  PaymentService();

  @override
  Future<PaymentResponse> getPaymentUrl(
      int uid, int registrationId, int whoAreYou) async {
    final url = '${Endpoints.payment}/$uid/$whoAreYou/$registrationId';
    final response = await globalApiService.get(url);
    return PaymentResponse.fromJson(response);
  }

  @override
  Future<CheckPaymentResponse> checkPayment(int uid, String url) async {
    final response = await globalApiService.post(Endpoints.checkPayment, {
      'userId': uid,
      'urlResponse': url,
    });
    final Map<String, dynamic> responseOT = {
      "responseCodeMessage": response['data']['responseCodeMessage'],
      "transactionStatusMessage": response['data']['transactionStatusMessage'],
      "vnPayResponse":
          VnPayResponse.fromJson(response['data']['vnPayResponse']),
      "statusCode": response['statusCode'],
    };
    return CheckPaymentResponse.fromJson(response);
  }

  @override
  Future<PaymentResponse> donateForTournament(
      int uid, int tournamentId, int amount) async {
    final response = await globalApiService.post(
        Endpoints.donateForTournament, {
      "sponnerId": uid,
      "touramentId": tournamentId,
      "returnUrl": 2,
      "amount": amount
    });
    return PaymentResponse.fromJson(response);
  }
}
