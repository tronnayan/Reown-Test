import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/features/auth/screens/widgets/bottomsheets/otp_bottomsheet.dart';
import 'package:peopleapp_flutter/features/auth/screens/widgets/social_connect/social_connect.dart';

class AuthBottomSheets {
  static void showOtpBottomSheet(BuildContext context,
      {required String email,
      required bool isLoading,
      required Function(String) onComplete,
      required Function() onResend}) {
    showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: ColorConstants.barrierColor,
      context: context,
      builder: (context) => OtpBottomSheet(
        isLoading: isLoading,
        email: email,
        onComplete: onComplete,
        onResend: onResend,
      ),
    );
  }

  static void showSocialConnectionsBottomSheet(BuildContext context,
      {required VoidCallback onDone}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SocialConnectionsSheet(onDone: onDone),
    );
  }
}
