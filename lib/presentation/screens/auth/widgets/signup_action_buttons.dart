import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/custom_elevated_button.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/auth/auth_state.dart';

class SignUpActionButtons extends StatelessWidget {
  final VoidCallback onSignUp;
  final VoidCallback onNavigateToLogin;

  const SignUpActionButtons({
    super.key,
    required this.onSignUp,
    required this.onNavigateToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppTheme.spacingLG),
        BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (previous, current) {
            // Only rebuild when loading state changes
            return previous.status != current.status;
          },
          builder: (context, state) {
            return CustomElevatedButton(
              onPressed: onSignUp,
              text: 'Sign Up',
              isLoading: state.status == AuthStatus.loading,
            );
          },
        ),
        const SizedBox(height: AppTheme.spacingMD),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: AppTheme.bodyTextSmall,
            ),
            TextButton(
              onPressed: onNavigateToLogin,
              child: const Text('Sign In'),
            ),
          ],
        ),
      ],
    );
  }
}
