class ApiRoutes {
  // Base URL
  static const String baseUrl =
      'https://worthy-swine-mutual.ngrok-free.app/api';

  // Auth Routes
  static const String login = '/account/login/';
  static const String verifyEmail = '/account/verify-email/';
  static const String userProfile = '/account/user-profile/';

  // Token Routes
  static const String createToken = '/account/create-new-token/';
}
