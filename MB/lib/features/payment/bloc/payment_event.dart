import 'package:equatable/equatable.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class InitiatePayment extends PaymentEvent {
  final int? registrationId;
  final int? amount;
  final int tournamentId;
  final PaymentMethod paymentMethod;

  const InitiatePayment(
      {this.registrationId, this.amount, required this.tournamentId, required this.paymentMethod});

  @override
  List<Object> get props => [];
}

class PaymentSuccess extends PaymentEvent {
  const PaymentSuccess();

  @override
  List<Object> get props => [];
}

class CheckPayment extends PaymentEvent {
  final int uid;
  final String url;
  final PaymentMethod paymentMethod;

  const CheckPayment({required this.uid, required this.url, required this.paymentMethod});

  @override
  List<Object> get props => [uid, url, paymentMethod];
}

class PaymentFailure extends PaymentEvent {
  final String error;

  const PaymentFailure(this.error);

  @override
  List<Object> get props => [error];
}

class DonateForTournamentSelect extends PaymentEvent {
  final int tournamentId;


  const DonateForTournamentSelect({required this.tournamentId});

  @override
  List<Object> get props => [tournamentId];
}

class ReturnUrlPaymentSuccess extends PaymentEvent {
  final String url;
  final int tournamentId;
  final PaymentMethod paymentMethod;

  const ReturnUrlPaymentSuccess(
      {required this.url, required this.tournamentId, required this.paymentMethod});

  @override
  List<Object> get props => [url, tournamentId, paymentMethod];
}
