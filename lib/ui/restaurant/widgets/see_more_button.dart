import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';

class SeeMoreButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SeeMoreButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.pressedColor;
          }
          return AppColors.buttonsColor;
        }),
      ),
      child: const Text("Ver mais"),
    );
  }
}
