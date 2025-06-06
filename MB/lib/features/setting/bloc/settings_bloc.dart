import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/services/match_send_request/dto/accept_request_dto.dart';
import 'package:pickleball_app/core/services/notification_model/dto/notification_dto.dart';
import 'package:pickleball_app/core/services/notification_model/service.dart';
import 'package:pickleball_app/features/match/bloc/match_bloc.dart';
import 'package:pickleball_app/features/match/bloc/match_event.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_event.dart';
import 'settings_event.dart';
import 'settings_state.dart';
import 'package:pickleball_app/core/models/models.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AppBloc appBloc;
  final TournamentBloc tournamentBloc;
  final MatchBloc matchBloc;
  final NotificationService _notificationService = NotificationService();

  SettingsBloc({required this.appBloc, required this.matchBloc, required this.tournamentBloc}) : super(SettingsInitial()) {
    on<LoadAllNotifications>(_onLoadAllNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<AcceptNotification>(_onAcceptNotification);
    on<RejectNotification>(_onRejectNotification);
  }

  Future<void> _onLoadAllNotifications(
      LoadAllNotifications event,
      Emitter<SettingsState> emit,
      ) async {
    emit(SettingsLoading());
    try {
      final appState = appBloc.state;
      List<NotificationDto> notifications = [];
      if (appState is AppAuthenticatedPlayer || appState is AppAuthenticatedSponsor) {
        final userId = (appState as dynamic).userInfo.id;
        notifications = await _notificationService.getAllNotifications(userId);
      }
      emit(SettingsLoaded(notifications));
    } catch (error) {
      emit(SettingsError(error.toString()));
    }
  }

  Future<void> _onMarkNotificationAsRead(
      MarkNotificationAsRead event,
      Emitter<SettingsState> emit,
      ) async {
    try {
      // TODO: Implement mark as read functionality
      add(LoadAllNotifications());
    } catch (error) {
      emit(SettingsError(error.toString()));
    }
  }
  Future<void> _onAcceptNotification(
      AcceptNotification event,
      Emitter<SettingsState> emit,
      ) async {
    try {
      final appState = appBloc.state;
      late int userId;
      if (appState is AppAuthenticatedPlayer || appState is AppAuthenticatedSponsor) {
        userId = (appState as dynamic).userInfo.id;
      }

      switch(event.notification.type){
        case 1:
          final response = await globalFriendService.acceptFriend(userId, event.notification.referenceId);
          if(response == true){
            await _notificationService.markAsRead(event.notification.id);
          }
          add(LoadAllNotifications());
        case 2:
          final response = await globalMatchSendRequestService.acceptRequest(AcceptRequestDTO(
              requestId: event.notification.referenceId,
              userAcceptId: userId,
              status: 1,
          ));
          if(response.data != null){
            await _notificationService.markAsRead(event.notification.id);
            matchBloc.add(SelectMatch(response.data!.matchingId));
            add(LoadAllNotifications());
          }
        case 3:
          final response = await globalTournamentTeamService.respondToTeamRequest(event.notification.referenceId, true);
            await _notificationService.markAsRead(event.notification.id);
            if(event.notification.bonusId != null){
              tournamentBloc.add(SelectTournament(event.notification.bonusId!));
            }
            add(LoadAllNotifications());
        case 4:
          tournamentBloc.add(SelectTournament(event.notification.referenceId));
        case 5:
          matchBloc.add(SelectMatch(event.notification.referenceId));
        default:
          return emit(SettingsError('Invalid notification type'));
      }
      add(LoadAllNotifications());
    } catch (error) {
      emit(SettingsError(error.toString()));
    }
  }

  Future<void> _onRejectNotification(
      RejectNotification event,
      Emitter<SettingsState> emit,
      ) async {
    try {
      add(LoadAllNotifications());
    } catch (error) {
      emit(SettingsError(error.toString()));
    }
  }
}