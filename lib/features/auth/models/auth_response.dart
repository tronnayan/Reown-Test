class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String accountUuid;
  final bool accountCreated;
  final String email;
  final String name;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.accountUuid,
    required this.accountCreated,
    required this.email,
    required this.name,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      userId: json['user_id']?.toString() ?? '',
      accountUuid: json['account_uuid'] ?? '',
      accountCreated: json['account_created'] ?? false,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user_id': userId,
      'account_uuid': accountUuid,
      'account_created': accountCreated,
      'email': email,
      'name': name,
    };
  }
} 