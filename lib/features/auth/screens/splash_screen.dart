import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/core/constants/image_constants.dart';
import 'package:peopleapp_flutter/core/services/get_it_service.dart';
import 'package:peopleapp_flutter/features/auth/providers/auth_provider.dart';
import 'package:peopleapp_flutter/core/routes/app_path_constants.dart';
import 'package:peopleapp_flutter/core/routes/app_routes.dart';
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
  late final AuthProvider authProvider = getIt<AuthProvider>();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // await reownProvider.initializeService(context);

      // After initialization, proceed with auth check
      final authProvider = getIt<AuthProvider>();
      final value = await authProvider.checkAuthStatus();

      if (mounted) {
        if (value != null) {
          NavigationService.navigateOffAll(
            context,
            !value.accountCreated
                ? RouteConstants.welcomeScreen
                : RouteConstants.createTokenScreen,
          );
        } else {
          NavigationService.navigateOffAll(
            context,
            RouteConstants.createTokenScreen,
          );
        }
      }
    } catch (e) {
      print('Error in SplashPage initialization: $e');
      if (mounted) {
        NavigationService.navigateOffAll(
          context,
          RouteConstants.createTokenScreen,
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
