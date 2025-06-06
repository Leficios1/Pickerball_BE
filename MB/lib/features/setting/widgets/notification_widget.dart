import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/services/notification_model/dto/notification_dto.dart';
import 'package:pickleball_app/core/utils/snackbar_helper.dart';
import 'package:pickleball_app/features/match/bloc/match_bloc.dart';
import 'package:pickleball_app/features/match/bloc/match_event.dart';
import 'package:pickleball_app/features/match/bloc/match_state.dart';
import 'package:pickleball_app/features/setting/bloc/settings_bloc.dart';
import 'package:pickleball_app/features/setting/bloc/settings_event.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_event.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_state.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../router/router.gr.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationDto notification;

  const NotificationItemWidget({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MatchBloc, MatchState>(listener: (context, state) {
          if (state is MatchDetailLoading) {
            AutoRouter.of(context).push(DetailMatchRoute());
          }
        }),
        BlocListener<TournamentBloc, TournamentState>(
            listener: (context, state) {
          if (state is TournamentDetailLoading) {
            AutoRouter.of(context).push(DetailTournamentRoute());
          }
        })
      ],
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: notification.isRead ? Colors.white : Colors.blue.shade50,
        child: InkWell(
            onTap: () {
              print(notification.type);
              if (notification.isRead) {
                SnackbarHelper.showSnackBar('Notification already read');
              } else {
                if( notification.type == 5) {
                  context.read<MatchBloc>().add(SelectMatch(notification.referenceId));
                  context.read<SettingsBloc>().add(MarkNotificationAsRead(notification.id));
                }else if(notification.type == 4){
                  context.read<TournamentBloc>().add(SelectTournament(notification.referenceId));
                  context.read<SettingsBloc>().add(MarkNotificationAsRead(notification.id));
                }else {
                  _showNotificationDetailDialog(context);
                }
              }
            },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(
                        _getNotificationIcon(),
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.message,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            timeago.format(
                              notification.createdAt
                                  .toLocal()
                                  .add(const Duration(hours: 7)),
                              locale: 'en',
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNotificationDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          NotificationDetailDialog(notification: notification),
    );
  }

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case 1:
        return Icons.event;
      case 2:
        return Icons.message;
      case 3:
        return Icons.card_giftcard;
      default:
        return Icons.notifications;
    }
  }
}

class NotificationDetailDialog extends StatelessWidget {
  final NotificationDto notification;

  const NotificationDetailDialog({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime localTime =
        notification.createdAt.toLocal().add(const Duration(hours: 7));
    final String formattedDate =
        "${localTime.day}/${localTime.month}/${localTime.year} ${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}";

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(
                    _getNotificationIcon(),
                    color: Colors.blue.shade700,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Notification Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Text(
              "Message:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              notification.message,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle action button press
                      },
                      child: const Text("Reject",
                          style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<SettingsBloc>()
                            .add(AcceptNotification(notification));
                        Navigator.of(context).pop();
                      },
                      child: const Text("Accept"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case 1:
        return Icons.event;
      case 2:
        return Icons.message;
      case 3:
        return Icons.card_giftcard;
      default:
        return Icons.notifications;
    }
  }
}
