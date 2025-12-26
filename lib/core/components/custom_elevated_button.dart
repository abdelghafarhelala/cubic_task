import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Reusable ElevatedButton component
///
/// By default:
/// - Takes full screen width (except padding)
/// - Has consistent height (56)
/// - Has consistent padding
///
/// Can be customized with:
/// - Custom width
/// - Custom height
/// - Custom style
/// - Loading state
/// - Icon support
class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final ButtonStyle? style;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: style ??
            ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor ?? AppTheme.textLight,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.textLight,
                  ),
                ),
              )
            : icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon),
                      const SizedBox(width: 8),
                      Text(text),
                    ],
                  )
                : Text(text),
      ),
    );
  }
}
