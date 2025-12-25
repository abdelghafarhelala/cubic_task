import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppTheme.spacingXXL),
        Icon(
          Icons.account_balance,
          size: 80,
          color: AppTheme.primaryBlue,
        ),
        const SizedBox(height: AppTheme.spacingLG),
        Text(
          'Welcome Back',
          style: AppTheme.heading1.copyWith(
            color: AppTheme.primaryBlue,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spacingSM),
        Text(
          'Sign in to your account',
          style: AppTheme.bodyTextSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spacingXXL),
      ],
    );
  }
}

