import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final bool hideText;
  final String? Function(String?)? validator;
  const MyTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hideText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: hideText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
