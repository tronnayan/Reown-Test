import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            height: 1,
            color: ColorConstants.greyText.withOpacity(0.3),
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: ColorConstants.greyText.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            height: 1,
            color: ColorConstants.greyText.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}
