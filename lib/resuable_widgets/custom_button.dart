import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final bool iconBeforeText; // New flag to control icon position
  final double radius;
  final double height;

  const CustomButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.iconBeforeText = false, // Default: Icon appears after text
    this.radius = 4.0,
    this.height = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFCF5D42), // Default reddish color
        borderRadius: BorderRadius.circular(radius),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null && iconBeforeText) ...[
              Icon(icon, color: iconColor ?? Colors.white),
              const SizedBox(width: 8),
            ],
            Text(
              buttonText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: textColor ?? Colors.white,
              ),
            ),
            if (icon != null && !iconBeforeText) ...[
              const SizedBox(width: 8),
              Icon(icon, color: iconColor ?? Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}
