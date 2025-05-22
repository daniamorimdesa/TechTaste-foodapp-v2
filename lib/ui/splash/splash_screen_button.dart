import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/_core/app_text_styles.dart';

class SplashScreenButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const SplashScreenButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<SplashScreenButton> createState() => _SplashScreenButtonState();
}

class _SplashScreenButtonState extends State<SplashScreenButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: _isPressed ? AppColors.pressedColor : AppColors.buttonsColor,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(widget.text, style: AppTextStyles.titleButtonSplash),
        ),
      ),
    );
  }
}
