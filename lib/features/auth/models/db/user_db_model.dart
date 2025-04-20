import 'package:hive/hive.dart';

part 'user_db_model.g.dart';

@HiveType(typeId: 0)
class UserDbModel extends HiveObject {
  @HiveField(0)
  final String refreshToken;

  @HiveField(1)
  final String accessToken;

  @HiveField(2)
  final int userId;

  @HiveField(3)
  final String accountUuid;

  @HiveField(4)
  final bool accountCreated;

  @HiveField(5)
  final String email;

  @HiveField(6)
  final String name;

  UserDbModel({
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

  factory UserDbModel.fromJson(Map<String, dynamic> json) {
    return UserDbModel(
      refreshToken: json['refresh_token'],
      accessToken: json['access_token'],
      userId: json['user_id'],
      accountUuid: json['account_uuid'],
      accountCreated: json['account_created'],
      email: json['email'],
      name: json['name'],
    );
  }
}
