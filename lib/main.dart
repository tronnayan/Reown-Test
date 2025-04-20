import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/features/auth/providers/authentication_provider.dart';
import 'package:peopleapp_flutter/features/auth/providers/reown_provider.dart';
import 'package:peopleapp_flutter/features/auth/screens/splash_screen.dart';
import 'package:peopleapp_flutter/core/routes/app_routes.dart';
import 'package:peopleapp_flutter/core/services/get_it_service.dart';
import 'package:peopleapp_flutter/core/services/reown/utils/deep_link_handler.dart';
import 'package:peopleapp_flutter/features/auth/service/user_db_service.dart';
import 'package:peopleapp_flutter/features/auth/service/wallet_db_service.dart';
import 'package:peopleapp_flutter/features/dashboard/provider/dashboard_provider.dart';
import 'package:peopleapp_flutter/features/main/provider/main_provider.dart';
import 'package:peopleapp_flutter/features/wallet/provider/wallet_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DeepLinkHandler.initListener();
  setupGetItServiceLocator();
  await HiveService.init();
  await UserDbService.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => MainProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => DashboardProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => AuthenticationProvider(),
      ),
      ChangeNotifierProvider(create: (_) => ReownProvider()),
      ChangeNotifierProxyProvider<ReownProvider, WalletProvider>(
        create: (context) => WalletProvider(context.read<ReownProvider>()),
        update: (context, reownProvider, previous) =>
            previous ?? WalletProvider(reownProvider),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'People Token App',
      theme: ThemeData(
        fontFamily: 'sonoma',
        primaryColor: ColorConstants.primaryPurple,
        scaffoldBackgroundColor: ColorConstants.darkBackground,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      routerConfig: AppRoutes.router,
    );
  }
}
