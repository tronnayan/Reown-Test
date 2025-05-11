import 'package:dio/dio.dart';
import 'package:peopleapp_flutter/core/exceptions/exceptions.dart';
import 'package:peopleapp_flutter/core/widgets/toast_widget.dart';

class ExceptionHandler {
  static handle(dynamic error) {
    final exception = _convertToAppException(error);

    // // Show user message
    // _showUserMessage(exception.message);

    // Log if needed
    if (exception.shouldLog) {
      _logError(exception);
    }

    return exception;
  }

  static AppException _convertToAppException(dynamic error) {
    if (error is AppException) return error;
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return ApiException(
            message:
                'Connection timeout. Please check your internet connection.',
            devDetails: error.toString(),
          );
        case DioExceptionType.connectionError:
          return ApiException(
            message: 'No internet connection.',
            devDetails: error.toString(),
          );
        case DioExceptionType.badResponse:
          return ApiException(
            message: 'Server error occurred.',
            devDetails:
                '${error.response?.statusCode}: ${error.response?.data}',
          );
        default:
          return ApiException(
            message: 'Network error occurred.',
            devDetails: error.toString(),
          );
      }
    }

    return ApiException(
      message: 'An unexpected error occurred',
      devDetails: error.toString(),
    );
  }

  static void _showUserMessage(String message) {
    Toast.show(message);
  }

  static void _logError(AppException exception) {
    print('🔴 Error[${exception.code}]: ${exception.message}');
    if (exception.devDetails != null) {
      print('🔴 Details: ${exception.devDetails}');
    }
  }
}
