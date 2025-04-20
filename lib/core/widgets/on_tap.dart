import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget onTap({required Widget widget, required Function onTap}) {
  return GestureDetector(
    onTap: () {
      onTap();
      HapticFeedback.lightImpact();
    },
    child: widget,
  );
}
