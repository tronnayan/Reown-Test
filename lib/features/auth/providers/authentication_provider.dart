import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:peopleapp_flutter/features/auth/repo/auth_repo.dart';
import 'package:peopleapp_flutter/features/auth/screens/widgets/bottomsheets/auth_bottomseets.dart';
import 'package:peopleapp_flutter/core/routes/app_path_constants.dart';
import 'package:peopleapp_flutter/core/routes/app_routes.dart';
import 'package:peopleapp_flutter/core/services/get_it_service.dart';
import 'package:peopleapp_flutter/core/services/toast_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final AuthRepo authRepo = getIt<AuthRepo>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginWithGoogle({required BuildContext context}) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      notifyListeners();
    } catch (e) {
      print(e);
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
      print('Error during Apple Sign-In: $error');
    }
  }

  Future<void> loginEmail(
      {required String email, required BuildContext context}) async {
    try {
      _setIsLoading(true);
      if (_checkEmail(email)) {
        final response = await authRepo.loginEmail(email: email);
        if (response.token.isNotEmpty) {
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

  Future<void> signUp(
      {required String email,
      required String name,
      required String dob,
      required BuildContext context}) async {
    try {
      if (_checkSignUpForm(email: email, name: name, dob: dob)) {
        _setIsLoading(true);
        final response =
            await authRepo.signUp(email: email, name: name, dob: dob);
        if (response.token.isNotEmpty) {
          _setIsLoading(false);
          NavigationService.navigateOffAll(
              context, RouteConstants.createTokenScreen);
        }
      }
    } catch (e) {
      _setIsLoading(false);
      throw Exception(e);
    }
  }

  Future<void> verifyOtp(
      {required String otp,
      required String email,
      required BuildContext context}) async {
    try {
      final response = await authRepo.verifyEmail(otp: otp, email: email);
      if (response.token.isNotEmpty) {
        NavigationService.navigateOffAll(
            context, RouteConstants.createTokenScreen);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> resendOtp(
      {required String email, required BuildContext context}) async {
    _setIsLoading(true);
    final response = await authRepo.loginEmail(email: email);
    if (response.token.isNotEmpty) {
      _setIsLoading(false);
    } else {}
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
}
