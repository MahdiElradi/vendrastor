/// Exceptions thrown from the data layer.
class ServerException implements Exception {
  const ServerException(this.message);
  final String message;
}

class UnauthorizedException implements Exception {
  const UnauthorizedException([this.message = 'Unauthorized']);
  final String message;
}

class ForbiddenException implements Exception {
  const ForbiddenException([this.message = 'Forbidden']);
  final String message;
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'Network error']);
  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Cache error']);
  final String message;
}
