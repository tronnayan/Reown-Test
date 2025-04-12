abstract class IAuthRepo {
  Future<void> loginEmail({required String email});
  Future<void> verifyEmail({required String email, required String otp});
  Future<void> signUp(
      {required String email, required String name, required String dob});
}
