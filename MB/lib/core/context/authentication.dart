import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pickleball_app/core/context/token.dart';

class SecureTokenService implements ITokenService {
  final FlutterSecureStorage _storage;

  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _expirationKey = 'expiration';

  SecureTokenService({required FlutterSecureStorage storage})
      : _storage = storage;

  // Access Token
  @override
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e) {
      print('Error reading access token: $e');
      return null;
    }
  }

  @override
  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(key: _accessTokenKey, value: token);
    } catch (e) {
      print('Error saving access token: $e');
    }
  }

  @override
  Future<void> deleteAccessToken() async {
    try {
      await _storage.delete(key: _accessTokenKey);
    } catch (e) {
      print('Error deleting access token: $e');
    }
  }

  // Refresh Token
  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      print('Error reading refresh token: $e');
      return null;
    }
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
    } catch (e) {
      print('Error saving refresh token: $e');
    }
  }

  @override
  Future<void> deleteRefreshToken() async {
    try {
      await _storage.delete(key: _refreshTokenKey);
    } catch (e) {
      print('Error deleting refresh token: $e');
    }
  }

  // Expiration
  @override
  Future<String?> getExpiration() async {
    try {
      final expiration = await _storage.read(key: _expirationKey);
      return expiration != null ? expiration : null;
    } catch (e) {
      print('Error reading expiration: $e');
      return null;
    }
  }

  @override
  Future<void> saveExpiration(String expiration) async {
    try {
      await _storage.write(key: _expirationKey, value: expiration);
    } catch (e) {
      print('Error saving expiration: $e');
    }
  }

  @override
  Future<void> deleteExpiration() async {
    try {
      await _storage.delete(key: _expirationKey);
    } catch (e) {
      print('Error deleting expiration: $e');
    }
  }

  @override
  Future<void> compareExpiration() async {
    final expirationString = await getExpiration();
    if (expirationString != null) {
      final expiration = DateTime.parse(expirationString);
      if (expiration.isBefore(DateTime.now())) {
        await clearAllTokens();
        throw Exception('Token expired');
      }
    }
  }

  // Clear all tokens
  @override
  Future<void> clearAllTokens() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      print('Error clearing all tokens: $e');
    }
  }
}
