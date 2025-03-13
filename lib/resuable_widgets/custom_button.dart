import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final bool iconBeforeText;
  final double radius;
  final double height;
  final bool isLoading; // New loading state

  const CustomButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.iconBeforeText = false,
    this.radius = 4.0,
    this.height = 50.0,
    this.isLoading = false, // Default: not loading
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed, // Disable clicks when loading
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: isLoading
              ? Colors.grey[400] // Grey when loading
              : backgroundColor ?? const Color(0xFFCF5D42), // Default color
          borderRadius: BorderRadius.circular(radius),
        ),
        child: TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2.5,
                  ),
                ) // Show loading indicator
              : Row(
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
      ),
    );
  }
}
