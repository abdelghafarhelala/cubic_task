import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/auth/auth_state.dart';

class LoginActionButtons extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onNavigateToSignUp;

  const LoginActionButtons({
    super.key,
    required this.onLogin,
    required this.onNavigateToSignUp,
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
              onPressed: isLoading ? null : onLogin,
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
                  : const Text('Sign In'),
            );
          },
        ),
        const SizedBox(height: AppTheme.spacingMD),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: AppTheme.bodyTextSmall,
            ),
            TextButton(
              onPressed: onNavigateToSignUp,
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ],
    );
  }
}
