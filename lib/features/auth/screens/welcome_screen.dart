import 'dart:io';

import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/image_constants.dart';
import 'package:peopleapp_flutter/core/routes/app_path_constants.dart';
import 'package:peopleapp_flutter/core/routes/app_routes.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/core/services/get_it_service.dart';
import 'package:peopleapp_flutter/core/widgets/custom_button.dart';
import 'package:peopleapp_flutter/features/auth/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final AuthenticationProvider authenticationProvider =
      getIt<AuthenticationProvider>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
      return Scaffold(
        backgroundColor: ColorConstants.darkBackground,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  right: 56,
                  top: 0,
                  bottom: 60,
                  left: 60,
                ),
                child: Image.asset(
                  ImageConstants.coinBg,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Tokenize\nYour Influence.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Transform social influence into tokens, and let your fans invest, trade, and grow with you.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          if (Platform.isIOS)
                            LoginButton(
                              text: 'Continue with Apple',
                              onPressed: _loginWithApple,
                              isPrimary: true,
                              isLoading: false,
                              imagePath: ImageConstants.appleIcon,
                            ),
                          const SizedBox(height: 16),
                          LoginButton(
                            text: 'Continue with Google',
                            onPressed: () =>
                                authProvider.loginWithGoogle(context: context),
                            isPrimary: true,
                            isLoading: false,
                            imagePath: ImageConstants.googleIcon,
                          ),
                          const SizedBox(height: 16),
                          LoginButton(
                            text: 'Continue with Email',
                            imagePath: ImageConstants.emailIcon,
                            onPressed: () => _loginWithEmail(context),
                            isPrimary: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Terms of Use',
                          style: TextStyle(
                            color: ColorConstants.greyText,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Privacy Policy',
                          style: TextStyle(
                            color: ColorConstants.greyText,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  _loginWithApple() {
    print('login with apple');
  }

  _loginWithEmail(BuildContext context) {
    NavigationService.navigateTo(context, RouteConstants.loginScreen);
  }
}
