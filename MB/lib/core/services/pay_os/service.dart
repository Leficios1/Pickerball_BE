import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/services/pay_os/interface.dart';
import 'package:pickleball_app/core/services/pay_os/dto/donate_request.dart';
import 'package:pickleball_app/core/services/pay_os/dto/join_tournament_request.dart';
import 'package:pickleball_app/core/services/pay_os/endpoints/endpoints.dart';

import 'dto/check_payment_response_payOS.dart';

class PayOsService implements IPayOsService {

  PayOsService();

  @override
  Future<String> getDonateUrl(DonateRequest request) async {
    final response = await globalApiService.get('${Endpoints.donate}?userId=${request.userId}&tourId=${request.tourId}&Amount=${request.amount}&linkReturn=2');
    return response['data'];

  }
  @override
  Future<String> getJoinTournamentUrl(JoinTournamentRequest request) async {
    final response = await globalApiService.get('${Endpoints.joinTournament}?userId=${request.userId}&tourId=${request.tourId}&linkReturn=2&registrationId=${request.registrationId}');
    return response['data'];
  }

  @override
  Future<CheckPaymentResponsePayOS> checkPayment(String orderId) async {
    final response = await globalApiService.get('${Endpoints.checkPayment}?orderCode=$orderId');
    return CheckPaymentResponsePayOS.fromJson(response['data']);
  }

}
