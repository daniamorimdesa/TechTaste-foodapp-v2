import 'package:flutter/material.dart';

class HomeDrawerButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color normalColor;
  final Color pressedColor;
  final Color textColor;
  final Color pressedTextColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const HomeDrawerButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.normalColor,
    required this.pressedColor,
    required this.textColor,
    required this.pressedTextColor,
    required this.fontSize,
    required this.fontWeight,
    this.textAlign = TextAlign.left,
  });

  @override
  State<HomeDrawerButton> createState() => _HomeDrawerButtonState();
}

class _HomeDrawerButtonState extends State<HomeDrawerButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: widget.onPressed != null ? _handleTapDown : null,
      onTapUp: widget.onPressed != null ? _handleTapUp : null,
      onTapCancel: widget.onPressed != null ? _handleTapCancel : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color:
              _isPressed && widget.onPressed != null
                  ? widget.pressedColor
                  : widget.normalColor,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text(
          widget.text,
          textAlign: widget.textAlign,
          style: TextStyle(
            color:
                _isPressed && widget.onPressed != null
                    ? widget.pressedTextColor
                    : widget.textColor,
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
          ),
        ),
      ),
    );
  }
}
