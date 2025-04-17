import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/core/constants/image_constants.dart';
import 'package:peopleapp_flutter/core/services/tap_gesture_service.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isLoading;
  final bool isDisabled;
  PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: widget.isLoading
            ? null
            : widget.isDisabled
                ? null
                : widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.isPrimary
              ? widget.isDisabled
                  ? ColorConstants.primaryPurple.withOpacity(0.5)
                  : ColorConstants.primaryPurple
              : widget.isDisabled
                  ? ColorConstants.secondaryBackground.withOpacity(0.5)
                  : ColorConstants.secondaryBackground,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide.none,
          ),
          elevation: 0,
        ),
        child: widget.isLoading
            ? Center(
                child: _lottieAnimation(),
              )
            : Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  _lottieAnimation() {
    return Lottie.asset(
      repeat: true,
      LottieConstants.loading,
      controller: _controller,
      onLoaded: (composition) {
        _controller.duration = composition.duration;
        _controller.forward().whenComplete(() => _controller.repeat());
      },
    );
  }
}

class LoginButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isLoading;
  final String imagePath;

  const LoginButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    required this.imagePath,
  });

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.isPrimary
              ? ColorConstants.primaryPurple
              : ColorConstants.secondaryBackground,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide.none,
          ),
          elevation: 0,
        ),
        child: widget.isLoading
            ? Center(
                child: _lottieAnimation(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    widget.imagePath,
                    width: 24,
                    height: 24,
                    fit: BoxFit.fill,
                    color: ColorConstants.white,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  _lottieAnimation() {
    return Lottie.asset(
      repeat: true,
      LottieConstants.loading,
      controller: _controller,
      onLoaded: (composition) {
        _controller.duration = composition.duration;
        _controller.forward().whenComplete(() => _controller.repeat());
      },
    );
  }
}

class CustomButton {
  static backButton(BuildContext context) {
    return onTap(
      onTap: () => Navigator.pop(context),
      widget: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorConstants.darkBackground,
            border: Border.all(color: ColorConstants.white, width: 1),
          ),
          child: const Icon(
            Icons.keyboard_arrow_left_rounded,
            color: ColorConstants.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}
