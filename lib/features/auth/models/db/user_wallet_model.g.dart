// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_wallet_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletDataAdapter extends TypeAdapter<WalletData> {
  @override
  final int typeId = 1;

  @override
  WalletData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalletData(
      walletAddress: fields[0] as String,
      walletBalance: fields[1] as double,
      chainId: fields[2] as String,
      chainName: fields[3] as String,
      currency: fields[4] as String,
      tokenName: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WalletData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.walletAddress)
      ..writeByte(1)
      ..write(obj.walletBalance)
      ..writeByte(2)
      ..write(obj.chainId)
      ..writeByte(3)
      ..write(obj.chainName)
      ..writeByte(4)
      ..write(obj.currency)
      ..writeByte(5)
      ..write(obj.tokenName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
