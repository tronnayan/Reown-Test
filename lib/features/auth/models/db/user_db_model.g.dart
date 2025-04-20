// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_db_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDbModelAdapter extends TypeAdapter<UserDbModel> {
  @override
  final int typeId = 0;

  @override
  UserDbModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDbModel(
      refreshToken: fields[0] as String,
      accessToken: fields[1] as String,
      userId: fields[2] as int,
      accountUuid: fields[3] as String,
      accountCreated: fields[4] as bool,
      email: fields[5] as String,
      name: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserDbModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.refreshToken)
      ..writeByte(1)
      ..write(obj.accessToken)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.accountUuid)
      ..writeByte(4)
      ..write(obj.accountCreated)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDbModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
