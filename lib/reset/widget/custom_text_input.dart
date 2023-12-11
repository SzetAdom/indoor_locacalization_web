import 'package:flutter/material.dart';

class CustomTextInput extends StatefulWidget {
  const CustomTextInput(
      {this.initText,
      this.onTextChanged,
      this.onTextSubmitted,
      this.hintText,
      this.multiline = false,
      Key? key})
      : super(key: key);

  final String? initText;
  final Function(String)? onTextChanged;
  final Function(String)? onTextSubmitted;
  final String? hintText;
  final bool? multiline;

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ]),
      child: TextField(
          keyboardType: widget.multiline == true
              ? TextInputType.multiline
              : TextInputType.text,
          maxLines: widget.multiline == true ? null : 1,
          controller: TextEditingController(text: widget.initText),
          onChanged: widget.onTextChanged,
          onSubmitted: (value) {
            widget.onTextSubmitted?.call(value);
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
          )),
    );
  }
}
