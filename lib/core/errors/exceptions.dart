/// Base Exception class for all custom exceptions
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

/// Server Exception
/// Thrown when there's an error from the server
class ServerException extends AppException {
  ServerException({required super.message, super.statusCode});
}

/// Cache Exception
/// Thrown when there's an error with local cache/storage
class CacheException extends AppException {
  CacheException({super.message = 'error_cache_failure'});
}

/// Network Exception
/// Thrown when there's no internet connection
class NetworkException extends AppException {
  NetworkException({
    super.message = 'error_network_message',
  });
}

/// Unauthorized Exception
/// Thrown when user is not authenticated
class UnauthorizedException extends AppException {
  UnauthorizedException({
    super.message = 'error_unauthorized_message',
    super.statusCode = 401,
  });
}

/// Forbidden Exception
/// Thrown when user doesn't have permission
class ForbiddenException extends AppException {
  ForbiddenException({
    super.message = 'error_forbidden_message',
    super.statusCode = 403,
  });
}

/// Not Found Exception
/// Thrown when resource is not found
class NotFoundException extends AppException {
  NotFoundException({
    super.message = 'error_not_found_message',
    super.statusCode = 404,
  });
}

/// Timeout Exception
/// Thrown when request times out
class TimeoutException extends AppException {
  TimeoutException({super.message = 'error_timeout_message'});
}

/// Validation Exception
/// Thrown when data validation fails
class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  ValidationException({
    super.message = 'error_validation_message',
    this.errors,
    super.statusCode = 422,
  });
}

/// Parse Exception
/// Thrown when JSON parsing fails
class ParseException extends AppException {
  ParseException({super.message = 'error_parse_failure'});
}
