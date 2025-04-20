class UserResponse {
  final int statusCode;
  final UserData data;

  UserResponse({
    required this.statusCode,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'data': data.toJson(),
    };
  }

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      statusCode: json['status_code'],
      data: UserData.fromJson(json['data']),
    );
  }

  UserResponse copyWith({
    int? statusCode,
    UserData? data,
  }) {
    return UserResponse(
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
    );
  }

  @override
  String toString() {
    return 'UserResponse(statusCode: $statusCode, data: $data)';
  }
}

class UserData {
  final int id;
  final String fullName;
  final String? displayPicture;
  final String email;
  final String connectedWalletAddress;

  UserData({
    required this.id,
    required this.fullName,
    this.displayPicture,
    required this.email,
    required this.connectedWalletAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'display_picture': displayPicture,
      'email': email,
      'connected_wallet_address': connectedWalletAddress,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      fullName: json['full_name'],
      displayPicture: json['display_picture'],
      email: json['email'],
      connectedWalletAddress: json['connected_wallet_address'],
    );
  }

  UserData copyWith({
    int? id,
    String? fullName,
    String? displayPicture,
    String? email,
    String? connectedWalletAddress,
  }) {
    return UserData(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      displayPicture: displayPicture ?? this.displayPicture,
      email: email ?? this.email,
      connectedWalletAddress:
          connectedWalletAddress ?? this.connectedWalletAddress,
    );
  }

  @override
  String toString() {
    return 'UserData(id: $id, fullName: $fullName, displayPicture: $displayPicture, email: $email, connectedWalletAddress: $connectedWalletAddress)';
  }
}
