abstract class ITokenService {
  Future<String?> getAccessToken();

  Future<void> saveAccessToken(String token);

  Future<void> deleteAccessToken();

  Future<String?> getRefreshToken();

  Future<void> saveRefreshToken(String token);

  Future<void> deleteRefreshToken();

  Future<String?> getExpiration();

  Future<void> saveExpiration(String expiration);

  Future<void> deleteExpiration();

  Future<void> compareExpiration();

  Future<void> clearAllTokens();
}
