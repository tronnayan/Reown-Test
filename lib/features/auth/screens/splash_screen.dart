import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/core/constants/image_constants.dart';
import 'package:peopleapp_flutter/core/services/get_it_service.dart';
import 'package:peopleapp_flutter/features/auth/providers/authentication_provider.dart';
import 'package:peopleapp_flutter/core/routes/app_path_constants.dart';
import 'package:peopleapp_flutter/core/routes/app_routes.dart';
import 'package:peopleapp_flutter/features/auth/providers/authentication_provider.dart';
import 'package:peopleapp_flutter/features/auth/providers/reown_provider.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with WidgetsBindingObserver {
  late final AuthenticationProvider authProvider =
      getIt<AuthenticationProvider>();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final authProvider = getIt<AuthenticationProvider>();
      final bool value = await authProvider.checkAuthStatus();
      // await context.read<ReownProvider>().initializeService(context);
      print(
          'isWalletConnected: ${context.read<ReownProvider>().isWalletConnected} ${context.read<ReownProvider>().isSessionValid()} ${context.read<ReownProvider>().isModalSession}');

      if (mounted) {
        if (value) {
          // if (await authProvider.checkWalletConnection()) {
          NavigationService.navigateOffAll(
            context,
            RouteConstants.mainScreen,
          );
          // } else {
          //   NavigationService.navigateOffAll(
          //     context,
          //     RouteConstants.createTokenScreen,
          //   );
          // }
        } else {
          NavigationService.navigateOffAll(
            context,
            RouteConstants.welcomeScreen,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        NavigationService.navigateOffAll(
          context,
          RouteConstants.welcomeScreen,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.darkBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 56, top: 20),
              child: Image.asset(
                ImageConstants.coinBg,
              ),
            ),
            const SizedBox(height: 64),
            Image.asset(
              ImageConstants.peopleLogo,
              height: 42,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              color: ColorConstants.primaryPurple,
            ),
            Container(
              margin: const EdgeInsets.only(right: 56, top: 20),
              child: Image.asset(
                ImageConstants.coinBg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
