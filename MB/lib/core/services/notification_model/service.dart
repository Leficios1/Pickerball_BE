import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/services/notification_model/dto/notification_dto.dart';
import 'package:pickleball_app/core/services/notification_model/endpoints/endpoints.dart';
import 'package:pickleball_app/core/services/notification_model/interface.dart';

class NotificationService extends INotificationService{

  @override
  Future<List<NotificationDto>> getAllNotifications(int id) async {
    try {
      final response = await globalApiService.get('${Endpoints.getAllNotifications}/$id');
      if (response['data'] == null) return [];

      return (response['data'] as List)
          .map<NotificationDto>((json) => NotificationDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print('NotificationService error: $error');
      throw Exception('Failed to load notifications');
    }
  }

  @override
  Future<bool> markAsRead(int id) async {
    try {
      final response = await globalApiService.get('${Endpoints.markAsRead}/$id');
      return response['data'];
    } catch (error) {
      print('NotificationService error: $error');
      throw Exception('Failed to mark notification as read');
    }
  }
}