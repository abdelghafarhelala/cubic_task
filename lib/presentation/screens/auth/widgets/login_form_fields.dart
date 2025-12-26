import 'package:flutter/material.dart';

import '../../../../core/components/custom_text_form_field.dart';
import '../../../../core/theme/app_theme.dart';

class LoginFormFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;

  const LoginFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
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
      ],
    );
  }
}
