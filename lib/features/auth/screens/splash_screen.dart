import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/core/constants/image_constants.dart';
import 'package:peopleapp_flutter/features/auth/providers/auth_provider.dart';
import 'package:peopleapp_flutter/core/routes/app_path_constants.dart';
import 'package:peopleapp_flutter/core/routes/app_routes.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with WidgetsBindingObserver {
  late final AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    try {
      authProvider = Provider.of<AuthProvider>(context, listen: false);

      // getIt.unregister<ReownAppKitModal>();
      // getIt.registerSingleton<ReownAppKitModal>(apiKitModel);
      // if (apiKitModel.isOpen) {
      authProvider.checkAuthStatus().then((value) {
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
      });
      // } else {
      //   NavigationService.navigateOffAll(
      //     context,
      //     RouteConstants.createTokenScreen,
      //   );
      // }
    } catch (e) {
      print('🟣 SplashPage: Error: on building apikitmodel $e');
      NavigationService.navigateOffAll(
        context,
        RouteConstants.createTokenScreen,
        extra: null,
      );
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
