import 'package:hive/hive.dart';

part 'user_wallet_model.g.dart';

@HiveType(typeId: 0)
class WalletData extends HiveObject {
  @HiveField(0)
  String walletAddress;

  @HiveField(1)
  double walletBalance;

  @HiveField(2)
  String chainId;

  @HiveField(3)
  String chainName;

  @HiveField(4)
  String currency;

  @HiveField(5)
  String tokenName;

  WalletData({
    required this.walletAddress,
    required this.walletBalance,
    required this.chainId,
    required this.chainName,
    required this.currency,
    required this.tokenName,
  });
}
