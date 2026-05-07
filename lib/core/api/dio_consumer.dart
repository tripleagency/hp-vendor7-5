import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../errors/exceptions.dart';
import 'api_consumer.dart';

/// Extension to support FormData (multipart) POST directly via Dio
extension DioConsumerMultipart on DioConsumer {
  Future<dynamic> postFormData(
    String path, {
    required FormData formData,
  }) async {
    try {
      final response = await client.post(path, data: formData);
      return response.data;
    } catch (e) {
      _handleException(e);
    }
  }
}

/// Concrete implementation of [ApiConsumer] using [Dio]
@lazySingleton
class DioConsumer implements ApiConsumer {
  final Dio client;

  DioConsumer({required this.client});

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      _handleException(e);
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client.post(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      _handleException(e);
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client.put(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      _handleException(e);
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client.delete(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      _handleException(e);
    }
  }

  @override
  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client.patch(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      _handleException(e);
    }
  }

  /// Centralized exception handler
  void _handleException(dynamic error) {
    if (error is DioException) {
      _handleDioException(error);
    } else {
      // Handle non-Dio fatal errors (TypeError, FormatException, etc.)
      throw ParseException(message: 'Unexpected error: ${error.toString()}');
    }
  }

  /// Map [DioException] to [AppException]
  void _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException();
      case DioExceptionType.badResponse:
        _handleBadResponse(error.response);
        break;
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.connectionError:
        throw NetworkException();
      case DioExceptionType.unknown:
        if (error.error != null &&
            error.error.toString().contains('SocketException')) {
          throw NetworkException();
        }
        throw ServerException(
          message: 'Something went wrong. Please try again.',
        );
      default:
        throw ServerException(
          message: 'Something went wrong. Please try again.',
        );
    }
  }

  void _handleBadResponse(Response? response) {
    if (response == null) {
      throw ServerException(message: 'Server returned an empty response.');
    }

    final int statusCode = response.statusCode ?? 500;
    final dynamic responseData = response.data;
    String message = _extractErrorMessage(responseData);

    switch (statusCode) {
      case 400:
        throw ServerException(message: message, statusCode: 400);
      case 401:
        throw UnauthorizedException(message: message);
      case 403:
        throw ForbiddenException(message: message);
      case 404:
        throw NotFoundException(message: message);
      case 422:
        throw ValidationException(
          message: message,
          errors: responseData is Map<String, dynamic> ? responseData : null,
        );
      case 500:
      default:
        throw ServerException(message: message, statusCode: statusCode);
    }
  }

  /// Robustly extract error message from response data.
  /// Prioritizes nested field errors (e.g. { "errors": { "phone": ["..."] } })
  /// so the user sees exactly which field failed validation, then falls back
  /// to the top-level "message" / "error" keys.
  String _extractErrorMessage(dynamic responseData) {
    if (responseData is Map) {
      // 1) Nested field errors first — these are the most informative.
      if (responseData['errors'] is Map) {
        final errors = responseData['errors'] as Map;
        if (errors.isNotEmpty) {
          final lines = <String>[];
          errors.forEach((field, value) {
            final fieldLabel = field.toString();
            if (value is List) {
              for (final v in value) {
                lines.add('$fieldLabel: $v');
              }
            } else {
              lines.add('$fieldLabel: $value');
            }
          });
          if (lines.isNotEmpty) return lines.join('\n');
        }
      }

      // 2) Top-level message / error keys as fallback.
      final keys = ['message', 'error', 'msg', 'errorMessage', 'detail'];
      for (final key in keys) {
        if (responseData.containsKey(key) && responseData[key] != null) {
          final val = responseData[key];
          if (val is String && val.trim().isNotEmpty) return val;
          if (val is List && val.isNotEmpty) return val.first.toString();
        }
      }
    }
    return 'Server Error';
  }
}
