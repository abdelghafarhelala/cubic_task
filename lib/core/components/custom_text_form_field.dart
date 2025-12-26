import 'package:flutter/material.dart';

import '../utils/input_validators.dart';

enum FieldType {
  email,
  password,
  phone,
  text,
  number,
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final FieldType fieldType;
  final IconData? prefixIcon;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool? enabled;
  final int? maxLines;
  final String? hintText;
  final String? helperText;
  final int? maxLength;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.fieldType = FieldType.text,
    this.prefixIcon,
    this.obscureText = false,
    this.onToggleVisibility,
    this.validator,
    this.keyboardType,
    this.enabled,
    this.maxLines = 1,
    this.hintText,
    this.helperText,
    this.maxLength,
  });

  IconData _getDefaultPrefixIcon() {
    switch (fieldType) {
      case FieldType.email:
        return Icons.email_outlined;
      case FieldType.password:
        return Icons.lock_outlined;
      case FieldType.phone:
        return Icons.phone_outlined;
      default:
        return Icons.text_fields_outlined;
    }
  }

  TextInputType _getDefaultKeyboardType() {
    switch (fieldType) {
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.phone:
        return TextInputType.phone;
      case FieldType.number:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  String? Function(String?)? _getDefaultValidator() {
    switch (fieldType) {
      case FieldType.email:
        return InputValidators.validateEmail;
      case FieldType.password:
        return InputValidators.validatePassword;
      case FieldType.phone:
        return InputValidators.validatePhone;
      default:
        return validator;
    }
  }

  Widget? _buildSuffixIcon() {
    if (fieldType == FieldType.password && onToggleVisibility != null) {
      return IconButton(
        icon: Icon(
          obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
        onPressed: onToggleVisibility,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? _getDefaultKeyboardType(),
      obscureText: fieldType == FieldType.password ? obscureText : false,
      enabled: enabled ?? true,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon)
            : Icon(_getDefaultPrefixIcon()),
        suffixIcon: _buildSuffixIcon(),
      ),
      validator: validator ?? _getDefaultValidator(),
    );
  }
}
