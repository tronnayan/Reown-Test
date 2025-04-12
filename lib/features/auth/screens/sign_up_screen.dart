import 'dart:io';
import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/features/auth/providers/authentication_provider.dart';
import 'package:peopleapp_flutter/features/auth/screens/widgets/bottomsheets/auth_bottomseets.dart';
import 'package:peopleapp_flutter/features/auth/screens/widgets/camera_picker_widget.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/core/widgets/custom_button.dart';
import 'package:peopleapp_flutter/features/auth/screens/widgets/form_feilds.dart';
import 'package:peopleapp_flutter/features/auth/screens/widgets/date_picker.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();

  DateTime? _selectedDate;
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: ColorConstants.darkBackground,
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 36,
                bottom: 176,
                left: 24,
                right: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 78),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Join the community of creators and investors',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  CameraPickerWidget(
                    onImageSelected: (imageFile) {
                      setState(() {
                        _imageFile = imageFile;
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  FormFields(
                    controller: _nameController,
                    label: 'Full Name',
                    hintText: 'Enter your full name',
                    enabled: true,
                  ),
                  const SizedBox(height: 16),
                  FormFields(
                    controller: _emailController,
                    label: 'Email',
                    hintText: 'Enter your email',
                    enabled: true,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  DOBPicker(
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        color: ColorConstants.primaryPurple,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: ColorConstants.primaryPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            _header(),
            _bottom(provider),
          ],
        ),
      );
    });
  }

  _header() {
    return Container(
      padding: const EdgeInsets.only(
        top: 56,
        bottom: 26,
        left: 16,
      ),
      decoration: BoxDecoration(
        color: ColorConstants.darkBackground,
        gradient: ColorConstants.darkBackgroundGradientTopBottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomButton.backButton(context),
        ],
      ),
    );
  }

  _bottom(AuthenticationProvider provider) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.only(
          top: 36,
          bottom: 26,
          left: 24,
          right: 24,
        ),
        decoration: BoxDecoration(
          color: ColorConstants.darkBackground,
          gradient: ColorConstants.darkBackgroundGradientBottomTop,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 44),
            PrimaryButton(
              text: 'Create Account',
              onPressed: () {
                AuthBottomSheets.showOtpBottomSheet(
                  context,
                  email: _emailController.text,
                  isLoading: false,
                  onComplete: (otp) {
                    provider.signUp(
                      email: _emailController.text,
                      name: _nameController.text,
                      dob: _selectedDate?.toString() ?? '',
                      context: context,
                    );
                  },
                  onResend: () {
                    provider.resendOtp(
                      email: _emailController.text,
                      context: context,
                    );
                  },
                );
              },
              isPrimary: true,
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}
