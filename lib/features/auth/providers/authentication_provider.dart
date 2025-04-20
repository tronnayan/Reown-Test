import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:peopleapp_flutter/core/exceptions/exceptions_handling.dart';
import 'package:peopleapp_flutter/core/routes/app_path_constants.dart';
import 'package:peopleapp_flutter/core/routes/app_routes.dart';
import 'package:peopleapp_flutter/features/auth/models/db/user_db_model.dart';
import 'package:peopleapp_flutter/features/auth/models/requests/login_request.dart';
import 'package:peopleapp_flutter/features/auth/models/responses/auth_response.dart';
import 'package:peopleapp_flutter/features/auth/models/responses/general_response.dart';
import 'package:peopleapp_flutter/features/auth/models/responses/user_response.dart';
import 'package:peopleapp_flutter/features/auth/repo/auth_repo.dart';
import 'package:peopleapp_flutter/core/services/get_it_service.dart';
import 'package:peopleapp_flutter/core/widgets/toast_widget.dart';
import 'package:peopleapp_flutter/features/auth/screens/widgets/bottomsheets/auth_bottomseets.dart';
import 'package:peopleapp_flutter/features/auth/service/google_service.dart';
import 'package:peopleapp_flutter/features/auth/service/user_db_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final AuthRepo authRepo = getIt<AuthRepo>();
  final GoogleAuthService googleAuthService = getIt<GoogleAuthService>();

  Future<void> loginWithGoogle({required BuildContext context}) async {
    try {
      final User? user = await googleAuthService.signInWithGoogle();
      if (user != null) {
        user.getIdToken().then((value) {
          final resp = authRepo.authenticate(
            request: LoginRequest(
              authType: AuthType.GOOGLE_LOGIN,
              email: user.email!,
              fullName: user.displayName!,
              otp: '',
              authToken: value ?? '',
            ),
          );
        });
      }
    } catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }

  Future<void> loginWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print('Apple ID Credential: ${appleCredential.toString()}');
    } catch (error) {
      throw ExceptionHandler.handle(error);
    }
  }

  Future<void> sentOtp(
      {required String email, required BuildContext context}) async {
    try {
      _setIsLoading(true);
      if (_checkEmail(email)) {
        final ApiResponse response = await authRepo.sendOtp(
          email: email,
        );
        print('send otp response: ${response.toString()}');
        if (response.statusCode == 200) {
          _setIsLoading(false);
          AuthBottomSheets.showOtpBottomSheet(context,
              email: email,
              isLoading: _isLoading,
              onComplete: (otp) =>
                  verifyOtp(context: context, email: email, otp: otp),
              onResend: () => resendOtp(email: email, context: context));
        }
        notifyListeners();
      }
      _setIsLoading(false);
    } catch (e) {
      _setIsLoading(false);
    }
  }

  Future<void> verifyOtp(
      {required String otp,
      required String email,
      required BuildContext context}) async {
    try {
      final AuthResponse response = await authRepo.authenticate(
        request: LoginRequest(
          authType: AuthType.EMAIL_LOGIN,
          email: email,
          fullName: '',
          otp: otp,
          authToken: '',
        ),
      );
      if (response.statusCode == 200) {
        await UserDbService.saveUserData(
            UserDbModel.fromJson(response.data.toJson()));
        NavigationService.navigateOffAll(
            context, RouteConstants.createTokenScreen);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signUp(
      {required String email,
      required String name,
      required String dob,
      required BuildContext context}) async {
    try {
      if (_checkSignUpForm(email: email, name: name, dob: dob)) {
        _setIsLoading(true);
        // final response =
        //     await authRepo.signUp(email: email, name: name, dob: dob);
        // if (response.token.isNotEmpty) {
        //   _setIsLoading(false);
        //   NavigationService.navigateOffAll(
        //       context, RouteConstants.createTokenScreen);
        // }
      }
    } catch (e) {
      _setIsLoading(false);
      throw Exception(e);
    }
  }

  Future<UserResponse> getUserDetails() async {
    try {
      final user = UserDbService.getUserData();
      if (user != null) {
        final UserResponse response = await authRepo.getUserDetails(
          accessToken: user.accessToken,
        );
        if (response.statusCode == 200) {
          return response;
        } else {
          throw ExceptionHandler.handle(response.statusCode);
        }
      }
      throw ExceptionHandler.handle("User not found");
    } catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }

  Future<void> resendOtp(
      {required String email, required BuildContext context}) async {
    _setIsLoading(true);
    // final response = await authRepo.loginEmail(email: email);
    // if (response.token.isNotEmpty) {
    //   _setIsLoading(false);
    // } else {}
    _setIsLoading(false);
  }

  bool _checkEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty) {
      Toast.show('Email is required');
      return false;
    } else if (!emailRegex.hasMatch(email)) {
      Toast.show('Invalid email');
      return false;
    } else {
      return true;
    }
  }

  _setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _checkSignUpForm(
      {required String email, required String name, required String dob}) {
    if (!_checkEmail(email)) {
      return false;
    } else {
      if (name.isEmpty) {
        Toast.show('Name is required');
        return false;
      } else if (dob.isEmpty) {
        Toast.show('Date of birth is required');
        return false;
      } else {
        return true;
      }
    }
  }

  Future<bool> checkAuthStatus() async {
    try {
      bool isUserLoggedIn = false;
      final UserResponse response = await getUserDetails();
      if (response.statusCode == 200) {
        isUserLoggedIn = true;
      }
      return isUserLoggedIn;
    } catch (e) {
      return false;
    }
  }
}
