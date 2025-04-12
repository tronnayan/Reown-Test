abstract class AppException implements Exception {
  final String message; // User-facing message
  final String? code; // Error code
  final String? devDetails; // Developer details
  final bool shouldLog; // Whether to log this exception

  const AppException({
    required this.message,
    this.code,
    this.devDetails,
    this.shouldLog = true, // Most exceptions should be logged by default
  });

  @override
  String toString() => 'Error[$code]: $message';
}

// Network related exceptions
class NetworkException extends AppException {
  NetworkException({
    String? message,
    String? code,
    String? devDetails,
  }) : super(
          message: message ?? 'Please check your internet connection',
          code: code ?? 'NETWORK_ERROR',
          devDetails: devDetails,
        );
}

// Authentication related exceptions
class AuthException extends AppException {
  final bool requiresLogout;

  AuthException({
    required String message,
    String? code,
    String? devDetails,
    this.requiresLogout = false,
  }) : super(
          message: message,
          code: code ?? 'AUTH_ERROR',
          devDetails: devDetails,
        );
}

// API related exceptions
class ApiException extends AppException {
  final int? statusCode;

  ApiException({
    required String message,
    this.statusCode,
    String? code,
    String? devDetails,
  }) : super(
          message: message,
          code: code ?? 'API_ERROR',
          devDetails: devDetails,
        );
}

// Validation exceptions (might not need logging)
class ValidationException extends AppException {
  ValidationException({
    required String message,
    String? code,
    String? devDetails,
  }) : super(
          message: message,
          code: code ?? 'VALIDATION_ERROR',
          devDetails: devDetails,
          shouldLog: false, // Validation errors typically don't need logging
        );
}
