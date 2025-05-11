import 'dart:convert';

import 'package:peopleapp_flutter/core/exceptions/exceptions_handling.dart';
import 'package:peopleapp_flutter/features/auth/models/requests/login_request.dart';
import 'package:peopleapp_flutter/features/auth/models/responses/auth_response.dart';
import 'package:peopleapp_flutter/features/auth/models/responses/general_response.dart';
import 'package:peopleapp_flutter/features/auth/models/responses/user_response.dart';
import 'package:peopleapp_flutter/features/auth/repo/i_auth_repo.dart';
import 'package:peopleapp_flutter/core/services/get_it_service.dart';
import 'package:peopleapp_flutter/network/http_services.dart';
import 'package:peopleapp_flutter/network/url_constants.dart';

class AuthRepo extends IAuthRepo {
  final HttpService httpService = getIt<HttpService>();

  @override
  Future<AuthResponse> authenticate({required LoginRequest request}) async {
    try {
      print('login request: ${request.toJson()}');

      var response = await httpService.postRequest(
        endpoint: EndPointsConstants.loginUrl,
        body: request.toJson(),
      );
      if (response.statusCode == 200) {
        print('login response: $response');
        return AuthResponse.fromJson(jsonDecode(response.body.toString()));
      } else {
        throw Exception('Login failed ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ApiResponse> sendOtp({required String email}) async {
    try {
      print('send otp request: ${EndPointsConstants.sendOtpUrl}');
      var response = await httpService.postRequest(
        endpoint: EndPointsConstants.sendOtpUrl,
        body: {'email': email},
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(jsonDecode(response.body.toString()));
      } else {
        throw ExceptionHandler.handle(response.body);
      }
    } catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }

  @override
  Future<UserResponse> getUserDetails({required String accessToken}) async {
    try {
      var response = await httpService.getRequestWithToken(
        endpoint: EndPointsConstants.getUserDetailsUrl,
        token: accessToken,
      );
      if (response.statusCode == 200) {
        return UserResponse.fromJson(jsonDecode(response.body.toString()));
      } else {
        throw ExceptionHandler.handle(response.body);
      }
    } catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }
}
