import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/errors/error_handler.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/services/user/dto/update_user_request.dart';
import 'package:pickleball_app/core/services/user/endpoints/endpoints.dart';

import 'dto/user_response.dart';
import 'interface.dart';

class UserService implements IUserService {
  UserService();

  @override
  Future<User> getUserById(int id) async {
    try {
      final response =
          await globalApiService.get('${EndPoints.getUserById}/$id');
      User user = User.fromJson(response['data']);
      return user;
    } catch (error) {
      print(error);
      throw ErrorHandler.handleApiError(error, 'en');
    }
  }

  @override
  Future<UserResponse> getAllUsers() async {
    try {
      final response = await globalApiService.get(EndPoints.getAllUser);
      return UserResponse.fromJson(response);
    } catch (error) {
      print(error);
      throw ErrorHandler.handleApiError(error, 'en');
    }
  }
  @override
  Future<UserResponse> getAllUsersNotFriend(int id) async {
    try {
      final response = await globalApiService.get('${EndPoints.getAllUserNotFriend}/$id');
      return UserResponse.fromJson(response);
    } catch (error) {
      print(error);
      throw ErrorHandler.handleApiError(error, 'en');
    }
  }

  @override
  Future<User> updateUser(UpdateUserRequest request, int id) async {
    try {
      final response = await globalApiService.patch(
          '${EndPoints.updateUser}/${id}', request.toJson());
      return User.fromJson(response['data']);
    } catch (error) {
      print(error);
      throw ErrorHandler.handleApiError(error, 'en');
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    try {
      await globalApiService.delete('${EndPoints.getUserById}/$id');
    } catch (error) {
      print(error);
      throw ErrorHandler.handleApiError(error, 'en');
    }
  }

  @override
  Future<UserResponse> getAllReferees() async {
    try {
      final response = await globalApiService.get(EndPoints.getAllReferees);
      return UserResponse.fromJson(response);
    } catch (error) {
      print(error);
      throw ErrorHandler.handleApiError(error, 'en');
    }
  }
}
