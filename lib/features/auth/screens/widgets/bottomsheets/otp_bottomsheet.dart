import 'dart:async';

import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/core/widgets/custom_button.dart';
import 'package:peopleapp_flutter/features/auth/providers/authentication_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpBottomSheet extends StatefulWidget {
  OtpBottomSheet({
    super.key,
    required this.email,
    this.isLoading = false,
    required this.onComplete,
    required this.onResend,
  });

  final String email;
  bool isLoading;
  final Function(String) onComplete;
  final Function() onResend;

  @override
  State<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  String otp = '';
  int _stopWatchSeconds = 30;
  Timer? _stopWatchTimer;
  bool _isStopWatchRunning = false;
  final TextEditingController _otpController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _startStopWatch();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
        builder: (context, provider, child) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: const BoxDecoration(
          color: ColorConstants.secondaryBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your OTP',
              style: TextStyle(
                color: ColorConstants.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your six digit OTP has been sent to your email',
              style: TextStyle(
                color: ColorConstants.greyText,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 36),
            Pinput(
              controller: _otpController,
              length: 6,
              onCompleted: (pin) => widget.onComplete(pin),
              defaultPinTheme: PinTheme(
                width: 56,
                height: 56,
                textStyle: const TextStyle(
                  fontSize: 20,
                  color: ColorConstants.white,
                ),
                decoration: BoxDecoration(
                  color: ColorConstants.darkBackground,
                  border: Border.all(color: ColorConstants.primaryPurple),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => widget.onResend(),
                child: Text(
                  _isStopWatchRunning
                      ? 'Resend OTP in ${_stopWatchSeconds}s'
                      : 'Re-send OTP',
                  style: TextStyle(
                    color: ColorConstants.primaryPurple,
                    fontSize: 18,
                    decoration:
                        !_isStopWatchRunning ? TextDecoration.underline : null,
                    decorationColor: ColorConstants.primaryPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Verify OTP',
              isPrimary: true,
              isLoading: provider.isLoading,
              onPressed: () => widget.onComplete(_otpController.text),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _cancelStopWatch();
    super.dispose();
  }

  _startStopWatch() {
    _isStopWatchRunning = true;
    _stopWatchSeconds = 30;
    _stopWatchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_stopWatchSeconds > 0) {
          setState(() {
            _stopWatchSeconds--;
          });
        } else {
          _isStopWatchRunning = false;
          _stopWatchTimer?.cancel();
        }
      });
    });
  }

  _cancelStopWatch() {
    _stopWatchSeconds = 30;
    _stopWatchTimer?.cancel();
    _isStopWatchRunning = false;
  }
}
