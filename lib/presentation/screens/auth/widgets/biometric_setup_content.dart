import 'package:flutter/material.dart';

import '../../../../core/components/custom_elevated_button.dart';
import '../../../../core/theme/app_theme.dart';

class BiometricSetupContent extends StatelessWidget {
  final bool isAvailable;
  final String biometricType;
  final bool isLoading;
  final VoidCallback onEnable;
  final VoidCallback onSkip;

  const BiometricSetupContent({
    super.key,
    required this.isAvailable,
    required this.biometricType,
    required this.isLoading,
    required this.onEnable,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isAvailable ? Icons.fingerprint : Icons.security,
          size: 100,
          color: AppTheme.primaryBlue,
        ),
        const SizedBox(height: AppTheme.spacingXL),
        Text(
          isAvailable ? 'Enable $biometricType' : 'Biometric Not Available',
          style: AppTheme.heading2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spacingMD),
        Text(
          isAvailable
              ? 'Use $biometricType for quick and secure access to your banking app'
              : 'Your device does not support biometric authentication. You can still use the app with your password.',
          style: AppTheme.bodyText,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spacingXXL),
        if (isAvailable)
          CustomElevatedButton(
            onPressed: onEnable,
            text: 'Enable $biometricType',
            isLoading: isLoading,
          ),
        const SizedBox(height: AppTheme.spacingMD),
        TextButton(
          onPressed: isLoading ? null : onSkip,
          child: const Text('Skip for now'),
        ),
      ],
    );
  }
}
