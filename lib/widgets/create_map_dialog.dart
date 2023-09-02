import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateMap extends StatefulWidget {
  const CreateMap({Key? key}) : super(key: key);

  @override
  State<CreateMap> createState() => _CreateMapState();
}

class _CreateMapState extends State<CreateMap> {
  bool editingName = false;
  bool editingDescription = false;
  bool editingWidth = false;
  bool editingHeight = false;

  FocusNode nameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode widthFocusNode = FocusNode();
  FocusNode heightFocusNode = FocusNode();

  late TextEditingController nameController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  late TextEditingController widthController = TextEditingController();
  late TextEditingController heightController = TextEditingController();

  String? _validateName(String value) {
    value = value.trim();

    if (nameController.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Name can\'t be empty';
      }
    }

    return null;
  }

  String? _validateWidth(String value) {
    value = value.trim();

    if (widthController.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Width can\'t be empty';
      } else if (double.tryParse(value) == null) {
        return 'Width must be a number';
      } else if (double.parse(value) < 50) {
        return 'Width must be minimum 50';
      }
    }
    return null;
  }

  String? _validateHeight(String value) {
    value = value.trim();

    if (heightController.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Height can\'t be empty';
      } else if (double.tryParse(value) == null) {
        return 'Height must be a number';
      } else if (double.parse(value) < 50) {
        return 'Height must be minimum 50';
      }
    }
    return null;
  }

  @override
  void initState() {
    nameController = TextEditingController(text: 'New map');
    descriptionController = TextEditingController(text: '');
    widthController = TextEditingController(text: '500');
    heightController = TextEditingController(text: '500');
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    widthController.dispose();
    heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Name'),
                TextField(
                  focusNode: nameFocusNode,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: nameController,
                  autofocus: false,
                  onChanged: (value) {
                    setState(() {
                      editingName = true;
                    });
                  },
                  onSubmitted: (value) {
                    nameFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(descriptionFocusNode);
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blueGrey[800]!,
                        width: 3,
                      ),
                    ),
                    filled: true,
                    hintStyle: TextStyle(
                      color: Colors.blueGrey[300],
                    ),
                    hintText: "Name",
                    fillColor: Colors.white,
                    errorText:
                        editingName ? _validateName(nameController.text) : null,
                    errorStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  focusNode: descriptionFocusNode,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: descriptionController,
                  autofocus: false,
                  onChanged: (value) {
                    setState(() {
                      editingDescription = true;
                    });
                  },
                  onSubmitted: (value) {
                    descriptionFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(widthFocusNode);
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blueGrey[800]!,
                        width: 3,
                      ),
                    ),
                    filled: true,
                    hintStyle: TextStyle(
                      color: Colors.blueGrey[300],
                    ),
                    hintText: "Description",
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Width'),
                TextField(
                  focusNode: widthFocusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
                  ],
                  textInputAction: TextInputAction.next,
                  controller: widthController,
                  autofocus: false,
                  onChanged: (value) {
                    setState(() {
                      editingWidth = true;
                    });
                  },
                  onSubmitted: (value) {
                    widthFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(heightFocusNode);
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blueGrey[800]!,
                        width: 3,
                      ),
                    ),
                    filled: true,
                    hintStyle: TextStyle(
                      color: Colors.blueGrey[300],
                    ),
                    hintText: "Width",
                    fillColor: Colors.white,
                    errorText: editingWidth
                        ? _validateWidth(widthController.text)
                        : null,
                    errorStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Height'),
                TextField(
                  focusNode: heightFocusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
                  ],
                  textInputAction: TextInputAction.next,
                  controller: heightController,
                  autofocus: false,
                  onChanged: (value) {
                    setState(() {
                      editingHeight = true;
                    });
                  },
                  onSubmitted: (value) {
                    heightFocusNode.unfocus();
                    // FocusScope.of(context).requestFocus(heightFocusNode);
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blueGrey[800]!,
                        width: 3,
                      ),
                    ),
                    filled: true,
                    hintStyle: TextStyle(
                      color: Colors.blueGrey[300],
                    ),
                    hintText: "Height",
                    fillColor: Colors.white,
                    errorText: editingHeight
                        ? _validateHeight(heightController.text)
                        : null,
                    errorStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          width: double.maxFinite,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.blueGrey.shade800,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () async {
                              if (nameController.text.isNotEmpty &&
                                  widthController.text.isNotEmpty &&
                                  heightController.text.isNotEmpty) {
                                if (_validateName(nameController.text) ==
                                        null &&
                                    _validateWidth(widthController.text) ==
                                        null &&
                                    _validateHeight(heightController.text) ==
                                        null) {
                                  var res = await FirebaseFirestore.instance
                                      .collection('maps')
                                      .add({
                                    'name': nameController.text,
                                    'description': descriptionController.text,
                                    'width': int.parse(widthController.text),
                                    'height': int.parse(heightController.text),
                                    'user_id': FirebaseAuth
                                            .instance.currentUser?.uid ??
                                        ''
                                  });

                                  Navigator.pushNamed(context, '/map-editor',
                                      arguments: res.id);
                                }
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(
                                top: 15.0,
                                bottom: 15.0,
                              ),
                              child: Text(
                                'Create map',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
