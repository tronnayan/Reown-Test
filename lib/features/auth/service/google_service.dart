import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  static const String apiKey = 'qdaKneXPnt4SZxYHrGNFFWPGz';
  static const String apiSecretKey =
      'V4320CYtgV0jv8MLP9vIKrKqEbKm7bSgI8mjJLlg7cIcuCMkp5';
  static const String redirectURI = 'peopleapp://';

  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('Google user is null');
        return null;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print("Sign-in error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

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
}
