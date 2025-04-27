import 'package:get_it/get_it.dart';
import 'package:peopleapp_flutter/core/services/reown/utils/crypto/spl_token_service.dart';
import 'package:peopleapp_flutter/features/auth/providers/authentication_provider.dart';
import 'package:peopleapp_flutter/features/auth/providers/reown_provider.dart';
import 'package:peopleapp_flutter/features/auth/repo/auth_repo.dart';
import 'package:peopleapp_flutter/features/auth/service/google_service.dart';
import 'package:peopleapp_flutter/features/dashboard/provider/dashboard_provider.dart';
import 'package:peopleapp_flutter/network/http_services.dart';
import 'package:reown_appkit/modal/appkit_modal_impl.dart';
import 'package:reown_appkit/modal/constants/string_constants.dart';
import 'package:peopleapp_flutter/network/url_constants.dart' as url_constants;

final getIt = GetIt.instance;

void setupGetItServiceLocator() {
  getIt.registerLazySingleton<ReownAppKitModal>(
      () => throw Exception("ReownAppKitModal is not implemented"));
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo());
  getIt.registerLazySingleton<AuthenticationProvider>(
      () => AuthenticationProvider());
  getIt.registerLazySingleton<DashboardProvider>(() => DashboardProvider());
  getIt.registerLazySingleton<ReownProvider>(() => ReownProvider());
  getIt.registerLazySingleton<SplTokenService>(() => SplTokenService());
  getIt.registerLazySingleton<GoogleAuthService>(() => GoogleAuthService());
  getIt.registerLazySingleton<HttpService>(
      () => HttpService(url_constants.EndPointsConstants.baseUrl));
}
