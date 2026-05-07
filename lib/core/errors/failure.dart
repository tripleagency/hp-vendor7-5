import 'package:equatable/equatable.dart';

/// Base Failure class
/// Represents business logic errors that should be displayed to users.
/// Default messages use localization keys that should be resolved via .tr()
/// at the UI layer for proper AR/EN translation.
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Server Failure
/// Represents errors from the server
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Cache Failure
/// Represents errors with local storage
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'error_cache_failure'});
}

/// Network Failure
/// Represents network connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'error_network_message',
  });
}

/// Unauthorized Failure
/// Represents authentication failures
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'error_unauthorized_message',
    super.code = 401,
  });
}

/// Forbidden Failure
/// Represents permission issues
class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.message = 'error_forbidden_message',
    super.code = 403,
  });
}

/// Not Found Failure
/// Represents resource not found errors
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'error_not_found_message',
    super.code = 404,
  });
}

/// Validation Failure
/// Represents validation errors
class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;

  const ValidationFailure({
    super.message = 'error_validation_message',
    this.errors,
    super.code = 422,
  });

  @override
  List<Object?> get props => [message, code, errors];
}

/// Timeout Failure
/// Represents request timeout errors
class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message = 'error_timeout_message'});
}

/// Unknown Failure
/// Represents unexpected errors
class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'error_generic_message'});
}
