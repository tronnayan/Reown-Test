import 'package:dio/dio.dart';
import 'package:peopleapp_flutter/core/exceptions/exceptions_handling.dart';
import 'package:peopleapp_flutter/features/auth/models/user_profile.dart';
import 'package:peopleapp_flutter/core/constants/api_routes.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  final dio = Dio();
  String? _authToken;

  ApiService._internal() {
    dio.options.baseUrl = ApiRoutes.baseUrl;
    dio.options.validateStatus = (status) => status! < 500;

    // dio.interceptors.add(InterceptorsWrapper(
    //   onRequest: (options, handler) {
    //     if (_authToken != null) {
    //       options.headers['Authorization'] = 'Bearer $_authToken';
    //     }
    //     return handler.next(options);
    //   },
    //   onError: (error, handler) {
    //     if (error.response?.statusCode == 401) {
    //       // Clear token on unauthorized
    //       clearAuthToken();
    //       // Throw specific error for auth provider to handle
    //       throw UnauthorizedException();
    //     }
    //     return handler.next(error);
    //   },
    // ));
  }

  void setAuthToken(String token) {
    _authToken = token;
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _authToken = null;
    dio.options.headers.remove('Authorization');
  }

  Future<Response> get(String path) async {
    try {
      return await dio.get(path);
    } catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      return await dio.post(path, data: data);
    } catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }

  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    try {
      return await dio.put(path, data: data);
    } catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }

  Future<Response> loginWithToken(String firebaseToken) async {
    try {
      final response = await dio.post(ApiRoutes.login, data: {
        'auth_type': 0,
        'auth_token': firebaseToken,
      });
      return response;
    } catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }

  Future<UserProfile> getUserProfile() async {
    try {
      final response = await dio.get(ApiRoutes.userProfile);
      print('🟣 User Profile API Response: ${response.data}');
      return UserProfile.fromJson(response.data['data']);
    } catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }
}
