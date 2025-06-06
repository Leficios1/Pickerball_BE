import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserInfoStorage {
  final FlutterSecureStorage _storage;

  UserInfoStorage({required FlutterSecureStorage storage}) : _storage = storage;

  Future<void> saveUserId(int userId) async {
    await _storage.write(key: 'user_id', value: userId.toString());
  }

  // Future<int> getUserId() async {
  //   final userId = await _storage.read(key: 'user_id');
  //   return int.parse(userId!);
  // }

  Future<void> deleteUserId() async {
    await _storage.delete(key: 'user_id');
  }
}
