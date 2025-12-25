import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/input_validators.dart';
import 'password_field.dart';

class SignUpFormFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final String? Function(String?)? validateConfirmPassword;

  const SignUpFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    this.validateConfirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          validator: InputValidators.validateEmail,
        ),
        const SizedBox(height: AppTheme.spacingMD),
        PasswordField(
          controller: passwordController,
          obscureText: obscurePassword,
          labelText: 'Password',
          onToggleVisibility: onTogglePassword,
        ),
        const SizedBox(height: AppTheme.spacingMD),
        PasswordField(
          controller: confirmPasswordController,
          obscureText: obscureConfirmPassword,
          labelText: 'Confirm Password',
          validator: validateConfirmPassword,
          onToggleVisibility: onToggleConfirmPassword,
        ),
      ],
    );
  }
}

