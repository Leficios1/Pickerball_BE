import 'package:pickleball_app/core/services/pay_os/dto/check_payment_response_payOS.dart';
import 'package:pickleball_app/core/services/pay_os/dto/donate_request.dart';
import 'package:pickleball_app/core/services/pay_os/dto/join_tournament_request.dart';

abstract class IPayOsService {
  /// Gets payment URL for donations
  Future<String> getDonateUrl(DonateRequest request);
  
  /// Gets payment URL for tournament registration
  Future<String> getJoinTournamentUrl(JoinTournamentRequest request);
  
  /// Verifies payment status
  Future<CheckPaymentResponsePayOS> checkPayment(String orderId);
}
