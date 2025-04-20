class ApiResponse {
  final int statusCode;
  final OtpData data;

  ApiResponse({
    required this.statusCode,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'data': data.toJson(),
    };
  }

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      statusCode: json['status_code'],
      data: OtpData.fromJson(json['data']),
    );
  }

  ApiResponse copyWith({
    int? statusCode,
    OtpData? data,
  }) {
    return ApiResponse(
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
    );
  }

  @override
  String toString() {
    return 'ApiResponse(statusCode: $statusCode, data: $data)';
  }
}

class OtpData {
  final String message;

  OtpData({
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }

  factory OtpData.fromJson(Map<String, dynamic> json) {
    return OtpData(
      message: json['message'],
    );
  }

  OtpData copyWith({
    String? message,
  }) {
    return OtpData(
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'ApiResponse(message: $message)';
  }
}
