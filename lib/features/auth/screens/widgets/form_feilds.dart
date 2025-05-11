import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';

class FormFields extends StatelessWidget {
  const FormFields({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.enabled = false,
    this.keyboardType = TextInputType.text,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool enabled;
  final TextInputType keyboardType;
  final Function(String value) onChanged;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ColorConstants.greyBackground,
          ),
        ),
        enabled: enabled,
        fillColor: ColorConstants.darkBackground.withOpacity(0.5),
        filled: true,
      ),
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
    );
  }
}
