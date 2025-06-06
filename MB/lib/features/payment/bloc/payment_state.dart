import 'package:equatable/equatable.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/services/pay_os/dto/check_payment_response_payOS.dart';
import 'package:pickleball_app/core/services/payment/dto/check_payment_response.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentInProgress extends PaymentState {}

class DonateInProgress extends PaymentState {}

class PaymentSuccessState extends PaymentState {
  final String message;

  const PaymentSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class CheckPaymentSuccess extends PaymentState {
  final int tournamentId;
  final CheckPaymentResponse? checkPaymentResponse;
  final CheckPaymentResponsePayOS? checkPaymentResponsePayOS;

  const CheckPaymentSuccess(
      {required this.tournamentId,  this.checkPaymentResponse, this.checkPaymentResponsePayOS});

  @override
  List<Object> get props => [tournamentId];
}

class OpenPaymentUrlState extends PaymentState {
  final String url;
  final int tournamentId;
  final PaymentMethod paymentMethod;

  const OpenPaymentUrlState({required this.url, required this.tournamentId, required this.paymentMethod});

  @override
  List<Object> get props => [url];
}

class PaymentFailureState extends PaymentState {
  final String error;

  const PaymentFailureState(this.error);

  @override
  List<Object> get props => [error];
}

class DonateForTournamentState extends PaymentState {
  final int tournamentId;

  const DonateForTournamentState({required this.tournamentId});

  @override
  List<Object> get props => [tournamentId];
}
