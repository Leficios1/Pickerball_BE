import 'package:pickleball_app/core/services/notification_model/dto/notification_dto.dart';

abstract class INotificationService {
  Future<List<NotificationDto>> getAllNotifications(int id);
  Future<bool> markAsRead(int id);
}