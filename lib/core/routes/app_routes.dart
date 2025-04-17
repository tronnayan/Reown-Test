import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleapp_flutter/features/auth/screens/create_token_screen.dart';
import 'package:peopleapp_flutter/features/auth/screens/login_screen.dart';
import 'package:peopleapp_flutter/features/auth/screens/sign_up_screen.dart';
import 'package:peopleapp_flutter/features/auth/screens/splash_screen.dart';
import 'package:peopleapp_flutter/features/auth/screens/welcome_screen.dart';
import 'package:peopleapp_flutter/features/main/screens/main_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import 'package:peopleapp_flutter/core/routes/app_path_constants.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: RouteConstants.splashScreen,
    routes: [
      GoRoute(
        path: RouteConstants.splashScreen,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteConstants.welcomeScreen,
        builder: (context, state) => WelcomeScreen(),
      ),
      GoRoute(
        path: RouteConstants.loginScreen,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: RouteConstants.signupScreen,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: RouteConstants.createTokenScreen,
        builder: (context, state) => const CreateTokenScreen(),
      ),
      GoRoute(
        path: RouteConstants.dashboardScreen,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: RouteConstants.mainScreen,
        builder: (context, state) => MainScreen(),
      ),
    ],
  );
}

class NavigationService {
  static void navigateTo(BuildContext context, String routePath,
      {Object? extra}) {
    context.push(routePath, extra: extra);
  }

  static void navigateOffAll(BuildContext context, String path,
      {Object? extra}) {
    context.go(path, extra: extra);
  }

  static void pop(BuildContext context) {
    context.pop();
  }
}
