import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool isPassword;
  final bool obscure;
  final VoidCallback? onToggleVisibility;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool readOnly;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.isPassword = false,
    this.obscure = false,
    this.onToggleVisibility,
    this.keyboardType = TextInputType.text,
    this.validator,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            )),
        const SizedBox(height: 6),
        TextFormField(
          readOnly: readOnly,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword ? !obscure : false,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: onToggleVisibility,
                    icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
