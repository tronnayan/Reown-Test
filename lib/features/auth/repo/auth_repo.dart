import 'package:peopleapp_flutter/core/constants/api_routes.dart';
import 'package:peopleapp_flutter/features/auth/models/login_response.dart';
import 'package:peopleapp_flutter/features/auth/repo/i_auth_repo.dart';
import 'package:peopleapp_flutter/core/services/api_service.dart';
import 'package:peopleapp_flutter/core/services/get_it_service.dart';

class AuthRepo extends IAuthRepo {
  final ApiService apiService = getIt<ApiService>();
  @override
  Future<LoginResponse> loginEmail({required String email}) async {
    try {
      Map<String, dynamic> data = {
        'email': email,
      };
      // final response = await apiService.post(ApiRoutes.login, data: data);

      if (true) {
        return LoginResponse.fromJson({'token': '1234567890'});
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<LoginResponse> verifyEmail(
      {required String email, required String otp}) async {
    try {
      Map<String, dynamic> data = {
        'email': email,
        'otp': otp,
      };
      // final response = await apiService.post(ApiRoutes.verifyEmail, data: data);

      if (true) {
        return LoginResponse.fromJson({'token': '1234567890'});
      } else {
        throw Exception('Failed to verify email');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<LoginResponse> signUp(
      {required String email,
      required String name,
      required String dob}) async {
    try {
      Map<String, dynamic> data = {
        'email': email,
        'name': name,
        'dob': dob,
      };
      // final response = await apiService.post(ApiRoutes.signUp, data: data);

      if (true) {
        return LoginResponse.fromJson({'token': '1234567890'});
      } else {
        throw Exception('Failed to sign up');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
