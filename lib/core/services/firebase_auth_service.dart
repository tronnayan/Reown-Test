import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Twitter API Keys from Firebase Console
  static const String apiKey = 'qdaKneXPnt4SZxYHrGNFFWPGz';
  static const String apiSecretKey = 'V4320CYtgV0jv8MLP9vIKrKqEbKm7bSgI8mjJLlg7cIcuCMkp5';
  static const String redirectURI = 'peopleapp://';

  // Future<UserCredential?> signInWithTwitter() async {
  //   try {
  //     // Create a TwitterLogin instance
  //     final twitterLogin = TwitterLogin(
  //       apiKey: apiKey,
  //       apiSecretKey: apiSecretKey,
  //       redirectURI: redirectURI,
  //     );
  //
  //     // Trigger the sign-in flow
  //     final authResult = await twitterLogin.login();
  //
  //     switch (authResult.status) {
  //       case TwitterLoginStatus.loggedIn:
  //         // Create a credential from the access token
  //         final twitterAuthCredential = TwitterAuthProvider.credential(
  //           accessToken: authResult.authToken!,
  //           secret: authResult.authTokenSecret!,
  //         );
  //
  //         // Sign in with the credential
  //         final userCredential = await _auth.signInWithCredential(twitterAuthCredential);
  //         return userCredential;
  //
  //       case TwitterLoginStatus.cancelledByUser:
  //         throw 'Twitter login cancelled by user';
  //
  //       case TwitterLoginStatus.error:
  //         throw 'Twitter login error: ${authResult.errorMessage}';
  //
  //       default:
  //         throw 'Unknown error occurred';
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
} 