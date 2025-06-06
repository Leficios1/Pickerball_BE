import 'package:pickleball_app/core/services/payment/dto/check_payment_response.dart';
import 'package:pickleball_app/core/services/payment/dto/payment_response.dart';

abstract class IPaymentService {
  Future<PaymentResponse> getPaymentUrl(
      int uid, int registrationId, int whoAreYou);

  Future<CheckPaymentResponse> checkPayment(int uid, String url);

  Future<PaymentResponse> donateForTournament(
      int uid, int tournamentId, int amount);
}
