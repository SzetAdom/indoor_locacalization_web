import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indoor_localization_web/reset/widget/my_text_input_field.dart';

class CrateMapPopUpWidget extends StatefulWidget {
  const CrateMapPopUpWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<CrateMapPopUpWidget> createState() => _CrateMapPopUpWidgetState();
}

class _CrateMapPopUpWidgetState extends State<CrateMapPopUpWidget> {
  // text editing controllers for my text input fields

  late TextEditingController _mapNameController;
  late TextEditingController _mapDescriptionController;
  late TextEditingController _mapImageController;

  @override
  void initState() {
    super.initState();
    // initialize text editing controllers
    _mapNameController = TextEditingController();
    _mapDescriptionController = TextEditingController();
    _mapImageController = TextEditingController();
  }

  @override
  void dispose() {
    // dispose text editing controllers
    _mapNameController.dispose();
    _mapDescriptionController.dispose();
    _mapImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // popup container with my text input fields for creating map model
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 450,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text(
            'Create Map',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          MyTextInputField(
            hintText: 'Map Name',
            controller: _mapNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          MyTextInputField(
            hintText: 'Map Description',
            controller: _mapDescriptionController,
            isTextArea: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          // MyTextInputField(
          //   hintText: 'Map Image',
          //   controller: _mapImageController,
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter an image';
          //     }
          //     return null;
          //   },
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          ElevatedButton(
            onPressed: () {
              // check if all text input fields are valid
              if (_mapNameController.text.isNotEmpty &&
                  _mapDescriptionController.text.isNotEmpty) {
                // close popup
                context.go('/map-editor/1');
              }
            },
            child: const Text('Create'),
          ),
        ]),
      ),
    );
  }
}
