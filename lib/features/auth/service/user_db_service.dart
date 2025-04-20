import 'package:hive_flutter/hive_flutter.dart';
import 'package:peopleapp_flutter/features/auth/models/db/user_db_model.dart';

class UserDbService {
  static const String userBox = 'user_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserDbModelAdapter());
    await Hive.openBox<UserDbModel>(userBox);
  }

  static Future<void> saveUserData(UserDbModel data) async {
    final box = Hive.box<UserDbModel>(userBox);
    await box.put('current_user', data);
  }

  static UserDbModel? getUserData() {
    final box = Hive.box<UserDbModel>(userBox);
    return box.get('current_user');
  }

  static Future<void> clearUserData() async {
    final box = Hive.box<UserDbModel>(userBox);
    await box.clear();
  }
}
