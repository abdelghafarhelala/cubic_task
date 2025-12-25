import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppTheme.spacingLG),
        Text(
          'Create Account',
          style: AppTheme.heading1.copyWith(
            color: AppTheme.primaryBlue,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spacingSM),
        Text(
          'Sign up to get started',
          style: AppTheme.bodyTextSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spacingXXL),
      ],
    );
  }
}

