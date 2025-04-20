class AuthResponse {
  final int statusCode;
  final AuthData data;

  AuthResponse({
    required this.statusCode,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'data': data.toJson(),
    };
  }

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      statusCode: json['status_code'],
      data: AuthData.fromJson(json['data']),
    );
  }

  AuthResponse copyWith({
    int? statusCode,
    AuthData? data,
  }) {
    return AuthResponse(
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
    );
  }

  @override
  String toString() {
    return 'AuthResponse(statusCode: $statusCode, data: $data)';
  }
}

class AuthData {
  final String refreshToken;
  final String accessToken;
  final int userId;
  final String accountUuid;
  final bool accountCreated;
  final String email;
  final String name;

  AuthData({
    required this.refreshToken,
    required this.accessToken,
    required this.userId,
    required this.accountUuid,
    required this.accountCreated,
    required this.email,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'refresh_token': refreshToken,
      'access_token': accessToken,
      'user_id': userId,
      'account_uuid': accountUuid,
      'account_created': accountCreated,
      'email': email,
      'name': name,
    };
  }

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      refreshToken: json['refresh_token'],
      accessToken: json['access_token'],
      userId: json['user_id'],
      accountUuid: json['account_uuid'],
      accountCreated: json['account_created'],
      email: json['email'],
      name: json['name'],
    );
  }

  AuthData copyWith({
    String? refreshToken,
    String? accessToken,
    int? userId,
    String? accountUuid,
    bool? accountCreated,
    String? email,
    String? name,
  }) {
    return AuthData(
      refreshToken: refreshToken ?? this.refreshToken,
      accessToken: accessToken ?? this.accessToken,
      userId: userId ?? this.userId,
      accountUuid: accountUuid ?? this.accountUuid,
      accountCreated: accountCreated ?? this.accountCreated,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return 'AuthData(refreshToken: $refreshToken, accessToken: $accessToken, userId: $userId, accountUuid: $accountUuid, accountCreated: $accountCreated, email: $email, name: $name)';
  }
}
