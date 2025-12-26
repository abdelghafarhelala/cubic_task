import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/custom_elevated_button.dart';
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
          buildWhen: (previous, current) {
            // Only rebuild when loading state changes
            return previous.status != current.status;
          },
          builder: (context, state) {
            return CustomElevatedButton(
              onPressed: onLogin,
              text: 'Sign In',
              isLoading: state.status == AuthStatus.loading,
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
