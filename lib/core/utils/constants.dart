import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryPurple = Color(0xFF7661DD);
  static const Color darkBackground = Color(0xFF11111D);
  static const Color secondaryBackground = Color(0xFF1D1D31);
  static const Color modalBackground = Color(0xFF171727);
  static const Color greyText = Color(0xFF8E8E93);
}

class AppStyles {
  static const TextStyle headingStyle = TextStyle(
    fontSize: 36,
    color: Colors.white,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 16,
    color: AppColors.greyText,
    height: 1.5,
  );
}
