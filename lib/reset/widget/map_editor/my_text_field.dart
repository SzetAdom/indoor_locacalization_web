import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatefulWidget {
  MyTextField({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.doubleOnly = false,
    this.alignment = MainAxisAlignment.end,
  }) : super(key: key);

  final String title;
  final String value;
  final Function(String value) onChanged;
  bool doubleOnly = false;
  MainAxisAlignment alignment;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.text = widget.value;
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.white)),
      child: TextField(
          controller: controller,
          cursorColor: Colors.white,
          enableInteractiveSelection: true,
          decoration: InputDecoration(
              labelText: widget.title,
              labelStyle: const TextStyle(color: Colors.white)),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            widget.onChanged(value);
          },
          inputFormatters: widget.doubleOnly
              ? [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))]
              : null),

      // TextField(
      //     decoration: InputDecoration(
      //         labelText: title,
      //         labelStyle: const TextStyle(color: Colors.white)),
      //     maxLines: 10,
      //     style: const TextStyle(color: Colors.white),
      //     keyboardType: TextInputType.number,
      //     controller: _textController,
      //     // onChanged: (value) {},
      //     // onSubmitted: (value) {},
      //     inputFormatters: doubleOnly
      //         ? [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))]
      //         : []),
    );
  }
}
