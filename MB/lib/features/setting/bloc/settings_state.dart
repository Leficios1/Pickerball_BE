import 'package:equatable/equatable.dart';
import 'package:pickleball_app/core/services/notification_model/dto/notification_dto.dart';

abstract class SettingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final List<NotificationDto> notifications;

  SettingsLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class SettingsError extends SettingsState {
  final String message;

  SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}