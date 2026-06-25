class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class RateLimitException implements Exception {
  final String message;
  RateLimitException(this.message);
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

class UserConflictException implements Exception {
  final String message;
  UserConflictException(this.message);
}

class WeakPasswordException implements Exception {
  final String message;
  WeakPasswordException(this.message);
}

class AuthenticationRequiredException implements Exception {
  final String message;
  AuthenticationRequiredException(this.message);
}

class BookUnavailableException implements Exception {
  final String message;
  BookUnavailableException(this.message);
}

class BookLockedException implements Exception {
  final String message;
  BookLockedException(this.message);
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
}
