import 'package:equatable/equatable.dart';
import 'package:pickleball_app/core/services/notification_model/dto/notification_dto.dart';

abstract class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAllNotifications extends SettingsEvent {}

class MarkNotificationAsRead extends SettingsEvent {
  final int notificationId;

  MarkNotificationAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class AcceptNotification extends SettingsEvent {
  final NotificationDto notification;

  AcceptNotification(this.notification);

  @override
  List<Object?> get props => [notification];
}

class RejectNotification extends SettingsEvent {
  final NotificationDto notification;

  RejectNotification(this.notification);

  @override
  List<Object?> get props => [notification];
}