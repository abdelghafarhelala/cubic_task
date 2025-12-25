import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          builder: (context, state) {
            final isLoading = state.status == AuthStatus.loading;
            return ElevatedButton(
              onPressed: isLoading ? null : onSignUp,
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
                  : const Text('Sign Up'),
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
