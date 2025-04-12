import 'package:flutter/material.dart';

class ColorConstants {
  static const Color primaryPurple = Color(0xFF7661DD);
  static const Color darkBackground = Color(0xFF11111D);
  static const Color secondaryBackground = Color.fromARGB(255, 28, 27, 27);
  static Color barrierColor = ColorConstants.greyText.withOpacity(0.4);
  static const Color modalBackground = Color(0xFF171727);
  static const Color greyText = Color(0xFF8E8E93);
  static Color greyBackground =
      Color.fromARGB(255, 190, 190, 192).withOpacity(0.8);
  static const Color white = Color(0xFFFFFFFF);

  static LinearGradient darkBackgroundGradientTopBottom = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      ColorConstants.darkBackground,
      ColorConstants.darkBackground,
      ColorConstants.darkBackground.withOpacity(0.8),
      ColorConstants.darkBackground.withOpacity(0.2),
      ColorConstants.darkBackground.withOpacity(0.0),
    ],
  );

  static LinearGradient darkBackgroundGradientBottomTop = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      ColorConstants.darkBackground,
      ColorConstants.darkBackground,
      ColorConstants.darkBackground.withOpacity(0.8),
      ColorConstants.darkBackground.withOpacity(0.2),
      ColorConstants.darkBackground.withOpacity(0.0),
    ],
  );
}
