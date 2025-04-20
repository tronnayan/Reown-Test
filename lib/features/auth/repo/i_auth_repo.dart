import 'package:peopleapp_flutter/features/auth/models/requests/login_request.dart';
import 'package:peopleapp_flutter/features/auth/models/responses/auth_response.dart';
import 'package:peopleapp_flutter/features/auth/models/responses/general_response.dart';
import 'package:peopleapp_flutter/features/auth/models/responses/user_response.dart';

abstract class IAuthRepo {
  Future<AuthResponse> authenticate({required LoginRequest request});
  Future<ApiResponse> sendOtp({required String email});
  Future<UserResponse> getUserDetails({required String accessToken});
}
