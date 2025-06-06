import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/errors/error_handler.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/services/authentication/dto/login_request.dart';
import 'package:pickleball_app/core/services/authentication/dto/refresh_token_request.dart';
import 'package:pickleball_app/core/services/authentication/dto/register_request.dart';
import 'package:pickleball_app/core/services/authentication/endpoints/endpoints.dart';
import 'package:pickleball_app/core/services/authentication/index.dart';

class AuthService implements IAuthService {
  AuthService();

  @override
  Future<User> login(LoginRequest request) async {
    try {
      final response = await globalApiService.post(
        EndPoints.login,
        request.toJson(),
      );
      final tokenString = response['data']['tokenString']?.toString();
      final expiration = response['data']['expiration']?.toString();
      if (tokenString != null && expiration != null) {
        await globalTokenService.saveAccessToken(tokenString);
        await globalTokenService.saveExpiration(expiration);
        final user = await getUserByToken(tokenString, 'en');
        return user;
      } else {
        throw Exception('Invalid response data');
      }
    } catch (error) {
      print(error);
      throw ErrorHandler.handleApiError(error);
    }
  }

  @override
  Future<int> register(RegisterRequest request) async {
    try {
      final response =
          await globalApiService.post(EndPoints.register, request.toJson());
      final user = response['data']['id'] as int;
      return user;
    } catch (error) {
      throw ErrorHandler.handleApiError(error, 'en');
    }
  }

  Future<User> getUserByToken(String token, String locale) async {
    try {
      final response = await globalApiService.get(
        '${EndPoints.getUserByToken}/$token',
        locale,
      );
      final user = response;
      return User.fromJson(user);
    } catch (error) {
      throw ErrorHandler.handleApiError(error, locale);
    }
  }

  @override
  Future<void> refreshToken(RefreshTokenRequest request) async {
    try {
      final response = await globalApiService.post(
        EndPoints.refreshToken,
        request.toJson(),
      );
      await globalTokenService.saveAccessToken(response['token']);
      await globalTokenService.saveRefreshToken(response['refreshToken']);
    } catch (error) {
      throw ErrorHandler.handleApiError(error);
    }
  }

  @override
  Future<void> logout() async {
    // Implement logout method
  }
}
