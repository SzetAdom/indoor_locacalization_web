import 'package:flutter/material.dart';

class MyTextInputField extends StatelessWidget {
  const MyTextInputField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.isTextArea = false,
  }) : super(key: key);

  final String hintText;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool isTextArea;

  @override
  Widget build(BuildContext context) {
    return Container(
      // custom design based on theme colors
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),

      child: TextFormField(
        maxLines: isTextArea ? 5 : 1,
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
