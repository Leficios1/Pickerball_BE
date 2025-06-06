import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/services/authentication/dto/login_request.dart';
import 'package:pickleball_app/core/services/authentication/dto/refresh_token_request.dart';
import 'package:pickleball_app/core/services/authentication/dto/register_request.dart';

abstract class IAuthService {
  Future<User> login(LoginRequest request);

  Future<int> register(RegisterRequest request);

  Future<void> logout();

  Future<void> refreshToken(RefreshTokenRequest request);
}
