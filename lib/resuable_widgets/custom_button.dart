import 'package:event_planner/utils/alerts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_planner/provider/connectivity_provider.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final String buttonLoadingText;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final bool iconBeforeText;
  final double radius;
  final double height;
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.icon,
    this.buttonLoadingText = "Please wait",
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.iconBeforeText = false,
    this.radius = 4.0,
    this.height = 50.0,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading
          ? null
          : () async {
              final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);
              if (!connectivityProvider.isConnected) {
                showNoInternetDialog(context);
                return;
              }
              onPressed();
            },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey[400] : backgroundColor ?? const Color(0xFFCF5D42),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: TextButton(
          onPressed: isLoading
              ? null
              : () async {
                  final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);
                  if (!connectivityProvider.isConnected) {
                    showNoInternetDialog(context);
                    return;
                  }
                  onPressed();
                },
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2.5,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      buttonLoadingText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: textColor ?? Colors.white,
                      ),
                    ),
                  ],
                )
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
