import 'package:hive_flutter/hive_flutter.dart';
import 'package:peopleapp_flutter/features/auth/models/db/user_wallet_model.dart';

class HiveService {
  static const String walletBox = 'wallet_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(WalletDataAdapter());
    await Hive.openBox<WalletData>(walletBox);
  }

  static Future<void> saveWalletData(WalletData data) async {
    final box = Hive.box<WalletData>(walletBox);
    await box.put('current_wallet', data);
  }

  static WalletData? getWalletData() {
    final box = Hive.box<WalletData>(walletBox);
    return box.get('current_wallet');
  }

  static Future<void> clearWalletData() async {
    final box = Hive.box<WalletData>(walletBox);
    await box.clear();
  }
}
