import 'package:flutter/material.dart';

import '../../../../core/components/custom_text_form_field.dart';
import '../../../../core/theme/app_theme.dart';

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
        CustomTextFormField(
          controller: emailController,
          labelText: 'Email',
          fieldType: FieldType.email,
        ),
        const SizedBox(height: AppTheme.spacingMD),
        CustomTextFormField(
          controller: passwordController,
          labelText: 'Password',
          fieldType: FieldType.password,
          obscureText: obscurePassword,
          onToggleVisibility: onTogglePassword,
        ),
        const SizedBox(height: AppTheme.spacingMD),
        CustomTextFormField(
          controller: confirmPasswordController,
          labelText: 'Confirm Password',
          fieldType: FieldType.password,
          obscureText: obscureConfirmPassword,
          onToggleVisibility: onToggleConfirmPassword,
          validator: validateConfirmPassword,
        ),
      ],
    );
  }
}
