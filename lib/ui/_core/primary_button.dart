import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color normalColor;
  final Color pressedColor;
  final Color textColor;
  final Color pressedTextColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final bool fullWidth;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.normalColor,
    required this.pressedColor,
    required this.textColor,
    required this.pressedTextColor,
    required this.fontSize,
    required this.fontWeight,
    this.textAlign = TextAlign.center,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        splashColor: pressedColor.withOpacity(0.3),
        highlightColor: pressedColor.withOpacity(0.2),
        child: Container(
          width: fullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: normalColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            textAlign: textAlign,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
