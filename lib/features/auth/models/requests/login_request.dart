enum AuthType {
  EMAIL_LOGIN,
  GOOGLE_LOGIN,
  APPLE_LOGIN,

  /*
    GOOGLE_LOGIN = 1
    APPLE_LOGIN = 2
    EMAIL_LOGIN = 0
    */
}

class LoginRequest {
  final AuthType authType;
  final String email;
  final String otp;
  final String fullName;
  final String authToken;
  LoginRequest({
    required this.authType,
    required this.email,
    this.otp = '',
    required this.fullName,
    this.authToken = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'auth_type': authType.index,
      'otp': otp,
      'email': email,
      'full_name': fullName,
      'auth_token': authToken,
    };
  }

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      authType: AuthType.values[json['auth_type']],
      email: json['email'],
      otp: json['otp'],
      fullName: json['full_name'],
      authToken: json['auth_token'],
    );
  }

  LoginRequest copyWith({
    AuthType? authType,
    String? email,
    String? otp,
    String? fullName,
  }) {
    return LoginRequest(
      authType: authType ?? this.authType,
      email: email ?? this.email,
      otp: otp ?? this.otp,
      fullName: fullName ?? this.fullName,
    );
  }

  @override
  String toString() {
    return 'UserAuthModel(authType: $authType, email: $email, otp: $otp, fullName: $fullName)';
  }
}
