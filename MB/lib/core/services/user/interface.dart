import 'package:pickleball_app/core/services/user/dto/update_user_request.dart';

import '../../models/models.dart';
import 'dto/user_response.dart';

abstract class IUserService {
  Future<User> getUserById(int id);

  Future<UserResponse> getAllUsers();

  Future<UserResponse> getAllUsersNotFriend(int id);

  Future<User> updateUser(UpdateUserRequest request, int id);

  Future<void> deleteUser(int id);

  Future<UserResponse> getAllReferees();
}
