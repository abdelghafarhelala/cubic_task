import 'package:flutter/material.dart';
import '../../../../core/utils/input_validators.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String labelText;
  final String? Function(String?)? validator;
  final VoidCallback onToggleVisibility;
  final bool? enabled;

  const PasswordField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.labelText,
    this.validator,
    required this.onToggleVisibility,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
      validator: validator ?? InputValidators.validatePassword,
      enabled: enabled ?? true,
    );
  }
}

