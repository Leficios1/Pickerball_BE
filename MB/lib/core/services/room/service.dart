import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/constants/router_path.dart';
import 'package:pickleball_app/core/errors/error_handler.dart';
import 'package:pickleball_app/core/models/simple_data.dart';
import 'package:pickleball_app/core/services/room/dtos/room_request.dart';
import 'package:pickleball_app/core/services/room/dtos/room_resqpond.dart';

class RoomService {
  RoomService();

  Future<Room> createRoom(RoomRequest roomData, [String? locale]) async {
    try {
      final response = await globalApiService.post(
        RouterPath.createRoom,
        roomData.toJson(),
        locale,
      );

      final roomResponse = RoomResponse.fromJson(response);
      return roomResponse.data;
    } catch (error) {
      // Xử lý lỗi nếu có
      print('error: $error');
      throw ErrorHandler.handleApiError(error, locale);
    }
  }

  Future<Room> getRoomById(String id, [String? locale]) async {
    try {
      final response = await globalApiService.get(
        '${RouterPath.getRoomById}$id',
        locale,
      );
      final roomResponse = RoomResponse.fromJson(response);
      return roomResponse.data;
    } catch (error) {
      throw ErrorHandler.handleApiError(error, locale);
    }
  }

  Future<Room> updateRoom(String id, Map<String, dynamic> updates,
      [String? locale]) async {
    try {
      final response = await globalApiService.put(
        '${RouterPath.getRoomById}$id',
        updates,
        locale,
      );
      final roomResponse = RoomResponse.fromJson(response);
      return roomResponse.data;
    } catch (error) {
      throw ErrorHandler.handleApiError(error, locale);
    }
  }

  Future<List<Room>> getAllRooms(
      {int page = 1,
      int limit = 10,
      String? startDate,
      String? endDate,
      String? locale}) async {
    try {
      final response = await globalApiService.get(
        '${RouterPath.getAllRoomPrivate}?page=$page&limit=$limit&startDate="$startDate"&endDate="$endDate"',
        locale,
      );
      final List<dynamic> data = response['data'];
      return data.map((json) => Room.fromJson(json)).toList();
    } catch (error) {
      throw ErrorHandler.handleApiError(error, locale);
    }
  }

  Future<List<Room>> getAllRoomsPublic(
      {required int page, int limit = 10, String? locale}) async {
    try {
      final response = await globalApiService.get(
        '${RouterPath.getAllRooms}?page=$page&limit=$limit"',
        locale,
      );
      final List<dynamic> data = response['data'];
      return data.map((json) => Room.fromJson(json)).toList();
    } catch (error) {
      throw ErrorHandler.handleApiError(error, locale);
    }
  }

  Future<List<Room>> getAllRoomsByUserId(String userId,
      {int page = 1, int limit = 10, String? locale}) async {
    try {
      final response = await globalApiService.get(
        '${RouterPath.getAllRoomByUserId}$userId?page=$page&limit=$limit"',
        locale,
      );
      final List<dynamic> data = response['data'];
      return data.map((json) => Room.fromJson(json)).toList();
    } catch (error) {
      throw ErrorHandler.handleApiError(error, locale);
    }
  }
}
