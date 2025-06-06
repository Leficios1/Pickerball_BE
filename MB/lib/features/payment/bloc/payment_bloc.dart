import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/services/pay_os/dto/donate_request.dart';
import 'package:pickleball_app/core/services/pay_os/dto/join_tournament_request.dart';
import 'package:pickleball_app/features/payment/bloc/payment_event.dart';
import 'package:pickleball_app/features/payment/bloc/payment_state.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_bloc.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final AppBloc appBloc;
  final TournamentBloc tournamentBloc;

  PaymentBloc({required this.appBloc, required this.tournamentBloc})
      : super(PaymentInitial()) {
    on<InitiatePayment>(_onInitiatePayment);
    on<ReturnUrlPaymentSuccess>(_onCheckPayment);
    on<DonateForTournamentSelect>(_onDonateForTournamentSelect);
  }

  Future<void> _onInitiatePayment(
      InitiatePayment event, Emitter<PaymentState> emit) async {
    emit(PaymentInProgress());
    try {
      final appState = appBloc.state;
      if (appState is AppAuthenticatedPlayer) {
        if (event.registrationId == null) {
          emit(PaymentFailureState('Registration ID is required'));
          return;
        } else {
          String url = '';
          if(event.paymentMethod == PaymentMethod.vnpay){
            final response = await globalPaymentService.getPaymentUrl(
                appState.userInfo.id, event.registrationId!, 1);
            url = response.data;
          }
          if(event.paymentMethod == PaymentMethod.payos){
            final JoinTournamentRequest joinTournamentRequest =
                JoinTournamentRequest(
                    registrationId: event.registrationId.toString(),
                  tourId: event.tournamentId.toString(),
                  userId: appState.userInfo.id.toString()
                );
            final response = await globalPayOsService.getJoinTournamentUrl(joinTournamentRequest);
            url = response;
          }

          emit(OpenPaymentUrlState(
              url: url, tournamentId: event.tournamentId, paymentMethod: event.paymentMethod));
        }
      } else if (appState is AppAuthenticatedSponsor) {
        if (event.amount == null) {
          emit(PaymentFailureState(
              'Amount is required, and tournament ID is required'));
          return;
        } else {
          String url = '';
          if(event.paymentMethod == PaymentMethod.vnpay){
            final response = await globalPaymentService.donateForTournament(
                appState.userInfo.id, event.tournamentId, event.amount!);
            url = response.data;
          }
          if(event.paymentMethod == PaymentMethod.payos){
            final DonateRequest donateRequest =
                DonateRequest(userId: appState.userInfo.id.toString(), tourId: event.tournamentId.toString(), amount: event.amount!.toDouble());
            final response = await globalPayOsService.getDonateUrl(donateRequest);
            url = response;
          }

          emit(OpenPaymentUrlState(
              url: url, tournamentId: event.tournamentId, paymentMethod: event.paymentMethod));
        }
      } else {
        emit(PaymentFailureState('User not authenticated'));
      }
    } catch (error) {
      emit(PaymentFailureState(error.toString()));
    }
  }

  Future<void> _onCheckPayment(
      ReturnUrlPaymentSuccess event, Emitter<PaymentState> emit) async {
    try {
      final appState = appBloc.state;
      if (appState is AppAuthenticatedPlayer) {
        emit(PaymentInProgress());
        if (event.paymentMethod == PaymentMethod.vnpay) {
          final response = await globalPaymentService.checkPayment(
              appState.userInfo.id, event.url);
          if (response.statusCode == 200) {
            emit(PaymentSuccessState(message: 'Payment successful'));
            emit(CheckPaymentSuccess(
                tournamentId: event.tournamentId,
                checkPaymentResponse: response));
          } else {
            emit(PaymentFailureState('Payment failed'));
          }
        } else if (event.paymentMethod == PaymentMethod.payos) {
          Uri uri = Uri.parse(event.url);
          String? orderCode = uri.queryParameters['orderCode'];
          if (orderCode == null) {
            emit(PaymentFailureState('Order code not found in URL'));
            return;
          }
          final response = await globalPayOsService.checkPayment(orderCode);
          emit(PaymentSuccessState(message: 'Payment successful'));
          emit(CheckPaymentSuccess(
              tournamentId: event.tournamentId,
              checkPaymentResponsePayOS: response));
        }
      } else if (appState is AppAuthenticatedSponsor) {
        emit(DonateInProgress());
        if (event.paymentMethod == PaymentMethod.vnpay) {
          final response = await globalPaymentService.checkPayment(
              appState.userInfo.id, event.url);
          if (response.statusCode == 200) {
            emit(PaymentSuccessState(message: 'Payment successful'));
            emit(CheckPaymentSuccess(
                tournamentId: event.tournamentId,
                checkPaymentResponse: response));
          } else {
            emit(PaymentFailureState('Payment failed'));
          }
        } else if (event.paymentMethod == PaymentMethod.payos) {
          Uri uri = Uri.parse(event.url);
          String? orderCode = uri.queryParameters['orderCode'];
          if (orderCode == null) {
            emit(PaymentFailureState('Order code not found in URL'));
            return;
          }
          final response = await globalPayOsService.checkPayment(orderCode);
          emit(PaymentSuccessState(message: 'Payment successful'));
          emit(CheckPaymentSuccess(
              tournamentId: event.tournamentId,
              checkPaymentResponsePayOS: response));
        }
      } else {
        emit(PaymentFailureState('User not authenticated'));
      }
    } catch (error) {
      emit(PaymentFailureState(error.toString()));
    }
  }

  Future<void> _onDonateForTournamentSelect(
      DonateForTournamentSelect event, Emitter<PaymentState> emit) async {
    emit(PaymentInProgress());
    try {} catch (error) {
      emit(PaymentFailureState(error.toString()));
    }
  }
}
