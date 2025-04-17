import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:peopleapp_flutter/features/auth/models/auth_response.dart';
import 'package:peopleapp_flutter/features/auth/models/user_profile.dart';
import 'package:peopleapp_flutter/core/services/api_service.dart';
import 'package:peopleapp_flutter/core/services/firebase_auth_service.dart';
import 'package:peopleapp_flutter/features/auth/providers/reown_provider.dart';
import 'package:reown_appkit/modal/appkit_modal_impl.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _firebaseAuth = FirebaseAuthService();
  final ApiService _apiService = ApiService();
  final ReownProvider _reownProvider = ReownProvider();
  late ReownAppKitModal appKitModal;

  AuthResponse? _authResponse;
  UserProfile? _userProfile;
  Map<String, dynamic>? _privyAuth;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  UserProfile? get userProfile => _userProfile;
  Map<String, dynamic>? get privyAuth => _privyAuth;

  initMethods() {}

  Future<void> updateAuthState(AuthResponse authResponse) async {
    _authResponse = authResponse;
    _isAuthenticated = true;

    // Fetch user profile right after authentication
    try {
      _apiService.setAuthToken(_authResponse!.accessToken);
      print('🟣 Fetching user profile after auth...');
      final profile = await _apiService.getUserProfile();
      print('🟣 Received profile: ${profile.toJson()}');
      _userProfile = profile;
      // await StorageService.saveAuthData(_authResponse!);

      await _fetchUserProfile();
      notifyListeners();
    } catch (e) {
      print('❌ Error fetching user profile: $e');
    }

    notifyListeners();
  }
  //
  // Future<AuthResponse?> signInWithTwitter() async {
  //   try {
  //     final userCredential = await _firebaseAuth.signInWithTwitter();
  //
  //     if (userCredential != null) {
  //       final firebaseToken = await userCredential.user?.getIdToken();
  //
  //       if (firebaseToken != null) {
  //         final response = await _apiService.loginWithToken(firebaseToken);
  //         _authResponse = AuthResponse.fromJson(response.data);
  //
  //         _apiService.setAuthToken(_authResponse!.accessToken);
  //         // await StorageService.saveAuthData(_authResponse!);
  //
  //         await _fetchUserProfile();
  //         return _authResponse;
  //       }
  //     }
  //   } catch (e) {
  //     await logout();
  //     rethrow;
  //   }
  //   return null;
  // }

  Future<AuthResponse?> checkAuthStatus() async {
    // try {
    //   final savedAuthData = await StorageService.getAuthData();
    //   log('🟣 Saved auth data: $savedAuthData');
    //   if (savedAuthData != null) {
    //     _authResponse = savedAuthData;
    //     _apiService.setAuthToken(_authResponse!.accessToken);

    //     await _fetchUserProfile();
    //     return savedAuthData;
    //   }
    //   return null;
    // } catch (e) {
    //   await logout();
    //   return null;
    // }
  }

  Future<void> _fetchUserProfile() async {
    try {
      print('🟣 Fetching user profile...');
      _userProfile = await _apiService.getUserProfile();
      print('🟣 Updated user profile: ${_userProfile?.toJson()}');
      notifyListeners();
    } catch (e) {
      print('❌ Error in _fetchUserProfile: $e');
      await logout();
      rethrow;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _apiService.clearAuthToken();
    // await StorageService.clearAuthData();
    _authResponse = null;
    _userProfile = null;
    _privyAuth = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges;
}
