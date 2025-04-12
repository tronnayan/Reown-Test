import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/features/auth/providers/authentication_provider.dart';
import 'package:peopleapp_flutter/features/auth/screens/splash_screen.dart';
import 'package:peopleapp_flutter/core/routes/app_routes.dart';
import 'package:peopleapp_flutter/core/services/get_it_service.dart';
import 'package:peopleapp_flutter/utils/deep_link_handler.dart';
import 'package:provider/provider.dart';
import 'package:peopleapp_flutter/features/auth/providers/auth_provider.dart';
import 'package:peopleapp_flutter/core/utils/constants.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DeepLinkHandler.initListener();
  setupGetItServiceLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => AuthenticationProvider(),
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
