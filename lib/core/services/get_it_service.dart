import 'package:get_it/get_it.dart';
import 'package:peopleapp_flutter/features/auth/providers/auth_provider.dart';
import 'package:peopleapp_flutter/features/auth/providers/authentication_provider.dart';
import 'package:peopleapp_flutter/features/auth/providers/reown_provider.dart';
import 'package:peopleapp_flutter/features/auth/repo/auth_repo.dart';
import 'package:peopleapp_flutter/core/services/api_service.dart';
import 'package:peopleapp_flutter/features/dashboard/provider/dashboard_provider.dart';
import 'package:reown_appkit/modal/appkit_modal_impl.dart';

final getIt = GetIt.instance;

void setupGetItServiceLocator() {
  getIt.registerLazySingleton<ReownAppKitModal>(
      () => throw Exception("ReownAppKitModal is not implemented"));
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo());
  getIt.registerLazySingleton<AuthenticationProvider>(
      () => AuthenticationProvider());
  getIt.registerLazySingleton<DashboardProvider>(() => DashboardProvider());
  getIt.registerLazySingleton<AuthProvider>(() => AuthProvider());
  getIt.registerLazySingleton<ReownProvider>(() => ReownProvider());
  // getIt.registerLazySingleton<SplTokenService>(() => SplTokenService());
}
