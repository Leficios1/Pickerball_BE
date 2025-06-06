import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/services/player_registration/dto/request/player_registration_request.dart';
import 'package:pickleball_app/features/payment/bloc/payment_bloc.dart';
import 'package:pickleball_app/features/payment/bloc/payment_event.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/join_tournament/join_tournament_event.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/join_tournament/join_tournament_state.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_event.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_state.dart';
import 'package:pickleball_app/router/router.gr.dart';

class JoinTournamentBloc
    extends Bloc<JoinTournamentEvent, JoinTournamentState> {
  final AppBloc appBloc;
  final TournamentBloc tournamentBloc;

  JoinTournamentBloc({required this.appBloc, required this.tournamentBloc})
      : super(JoinTournamentInitial()) {
    on<JoinTournamentRequested>(_onJoinTournamentRequested);
  }

  Future<void> _onJoinTournamentRequested(
      JoinTournamentRequested event, Emitter<JoinTournamentState> emit) async {
    emit(TournamentJoining());
    try {
      final appsState = appBloc.state;
      final tournamentState = tournamentBloc.state;

      if (tournamentState is TournamentDetailLoaded) {
        final tournament = tournamentState.tournament;
        if (appsState is AppAuthenticatedPlayer) {
          final register = await globalPlayerRegistrationService
              .createRegistration(PlayerRegistrationRequest(
            tournamentId: tournament.id,
            playerId: appsState.userInfo.id,
            partnerId: event.partnerId,
          ));

          if (event.context.mounted) {
            final router = AutoRouter.of(event.context);
            if (event.partnerId != null) {
              final isDoubles = tournamentState.tournament.type ==
                      MatchFormat.doubleMix.label ||
                  tournamentState.tournament.type ==
                      MatchFormat.doubleMale.label ||
                  tournamentState.tournament.type ==
                      MatchFormat.doubleFemale.label;
              if (isDoubles == true) {
                tournamentBloc
                    .add(SelectTournament(tournamentState.tournament.id));
                router.popAndPush(DetailTournamentRoute());
              }
              emit(TournamentJoined(false,
                  'You have created a team, please wait for your teammates to accept the invitation.'));
            } else {
              if (!tournament.isFree) {
                tournamentBloc
                    .add(SelectTournament(tournamentState.tournament.id));
                router.popAndPush(DetailTournamentRoute());
                emit(TournamentJoined(
                    true, 'You have successfully joined the tournament.'));
              } else {
                BlocProvider.of<PaymentBloc>(event.context).add(
                  InitiatePayment(
                      registrationId: register.id, tournamentId: tournament.id, paymentMethod: event.paymentMethod),
                );
                emit(TournamentJoined(false,
                    'Please pay the registration fee to join the tournament.'));
              }
            }
          }
        } else {
          emit(JoinTournamentError('User not authenticated'));
        }
      }
    } catch (error) {
      emit(JoinTournamentError('Error joining tournament'));
    }
  }
}
