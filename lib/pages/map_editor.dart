import 'dart:developer' as dev;
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:indoor_localization_web/controllers/map_object_data_ontroller.dart';
import 'package:indoor_localization_web/models/map_object.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:provider/provider.dart';

class MapEditor extends StatefulWidget {
  const MapEditor({Key? key}) : super(key: key);

  @override
  State<MapEditor> createState() => _MapEditorState();
}

class _MapEditorState extends State<MapEditor> {
  final MapObjectDataController _mapObjectController =
      MapObjectDataController();

  @override
  void initState() {
    super.initState();
  }

  Matrix4 matrix = Matrix4.identity();
  ValueNotifier<int> notifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Text('Térkép szekesztése'),
        ),
        body: ChangeNotifierProvider<MapObjectDataController>(
          create: (context) => _mapObjectController,
          child: Consumer<MapObjectDataController>(
            builder: (context, value, child) => Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      LayoutBuilder(
                        builder: (ctx, constraints) {
                          return MatrixGestureDetector(
                            shouldRotate: false,
                            shouldScale: false,
                            shouldTranslate: _mapObjectController.mapSelected,
                            onMatrixUpdate: (m, tm, sm, rm) {
                              matrix = MatrixGestureDetector.compose(
                                  matrix, tm, sm, null);

                              notifier.value++;
                            },
                            child: GestureDetector(
                              onTap: () {
                                _mapObjectController.setMapSelected();
                              },
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.topLeft,
                                color: const Color(0xff444444),
                                child: AnimatedBuilder(
                                  animation: notifier,
                                  builder: (ctx, child) {
                                    return Transform(
                                      transform: matrix,
                                      child: OverflowBox(
                                        minHeight: 0,
                                        minWidth: 0,
                                        maxHeight: double.infinity,
                                        maxWidth: double.infinity,
                                        child: Container(
                                          width: 500,
                                          height: 500,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: Container(
                                            color: Colors.grey.shade200,
                                            child: GridPaper(
                                              color: Colors.black,
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  ...Provider.of<
                                                              MapObjectDataController>(
                                                          context,
                                                          listen: true)
                                                      .objects
                                                      .mapIndexed((i, e) =>
                                                          AnimatedBuilder(
                                                            animation: e.widget,
                                                            builder: (context,
                                                                child) {
                                                              e.buildWidget();
                                                              return e
                                                                  .widget.value;
                                                            },
                                                          ))
                                                      .toList(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 10,
                        right: 70,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              matrix.scale(1.2, 1.2);
                            });
                          },
                          child: Stack(
                            children: const [
                              Positioned(
                                left: 1.0,
                                top: 3.0,
                                child: Icon(
                                  Icons.zoom_in,
                                  color: Colors.black,
                                  size: 50,
                                ),
                              ),
                              Icon(
                                Icons.zoom_in,
                                color: Colors.white,
                                size: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              matrix.scale(0.8, 0.8);
                            });
                          },
                          child: Stack(
                            children: const [
                              Positioned(
                                left: 1.0,
                                top: 3.0,
                                child: Icon(
                                  Icons.zoom_out,
                                  color: Colors.black,
                                  size: 50,
                                ),
                              ),
                              Icon(
                                Icons.zoom_out,
                                color: Colors.white,
                                size: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const MapObjectControlPanel(),
              ],
            ),
          ),
        ));
  }
}

class MapObjectControlPanel extends StatefulWidget {
  const MapObjectControlPanel({Key? key}) : super(key: key);

  @override
  State<MapObjectControlPanel> createState() => _MapObjectControlPanelState();
}

class _MapObjectControlPanelState extends State<MapObjectControlPanel> {
  final double controllerWidth = 100;

  Future<void> _displayTextInputDialog(BuildContext context,
      {required String title,
      required String hintText,
      String defaultValue = '',
      required Function onSave}) async {
    final TextEditingController _textFieldController = TextEditingController();
    _textFieldController.text = defaultValue;

    void _onSave(BuildContext context) {
      if (_textFieldController.text != '') {
        dev.log('Teszt: ${_textFieldController.text}');
        setState(() {
          onSave(_textFieldController.text);
          Navigator.pop(context);
        });
      }
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: hintText),
              onSubmitted: (value) {
                _onSave(context);
              },
            ),
            actions: <Widget>[
              Container(
                color: Colors.red,
                child: TextButton(
                  child: const Text(
                    'Mégse',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
              Container(
                color: Colors.green,
                child: TextButton(
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _onSave(context);
                  },
                ),
              ),
            ],
          );
        });
  }

  String? someValue;

  void setSomeValue(String? value) {
    setState(() {
      someValue = value;
    });
  }

  _pickIcon(BuildContext context) async {
    IconData? icon = await FlutterIconPicker.showIconPicker(
      context,
      customIconPack: ,
    );

    if (icon != null) {
      Provider.of<MapObjectDataController>(context, listen: false)
          .addIcon(Icon(icon));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var objectProvider = Provider.of<MapObjectDataController>(context);
    return Container(
      color: Colors.blueGrey,
      width: 400,
      child: SizedBox.expand(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
              height: 400,
              child: ListView.builder(
                itemCount: objectProvider.objects.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      objectProvider.setSelected(index);
                    },
                    child: Container(
                      height: 30,
                      color: objectProvider.objects[index].selected
                          ? Colors.grey.shade400
                          : Colors.white,
                      child: Text(
                        objectProvider.objects[index].name,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15, left: 20),
                            child: const Text(
                              'Width (m):',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            color: Colors.white,
                            width: 70,
                            height: 50,
                            child: TextField(
                                style: const TextStyle(color: Colors.black),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  objectProvider.setWidth(double.parse(value));
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'(^\d*\.?\d*)'))
                                ]),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15, left: 20),
                            child: const Text(
                              'Height (m):',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            color: Colors.white,
                            width: 70,
                            height: 50,
                            child: TextField(
                                style: const TextStyle(color: Colors.black),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  objectProvider.setHeight(double.parse(value));
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'(^\d*\.?\d*)'))
                                ]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15, left: 20),
                            child: const Text(
                              'X:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15, right: 20),
                            color: Colors.white,
                            width: 70,
                            height: 50,
                            child: TextField(
                                style: const TextStyle(color: Colors.black),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  objectProvider.setX(double.parse(value));
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'(^\d*\.?\d*)'))
                                ]),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15, left: 20),
                            child: const Text(
                              'Y:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15, right: 20),
                            color: Colors.white,
                            width: 70,
                            height: 50,
                            child: TextField(
                                style: const TextStyle(color: Colors.black),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  objectProvider.setY(double.parse(value));
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'(^\d*\.?\d*)'))
                                ]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 25, right: 15),
                    child: const Text('Rotate:',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Transform.rotate(
                      angle: -pi / 2,
                      child: IconButton(
                        onPressed: () {
                          Provider.of<MapObjectDataController>(context,
                                  listen: false)
                              .rotateObject(45);
                        },
                        enableFeedback: true,
                        icon: const Icon(Icons.rotate_left),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 15),
                    child: const Text('Name:',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    width: 300,
                    height: 50,
                    margin: const EdgeInsets.only(right: 15),
                    color: Colors.white,
                    child: const TextField(),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 25, right: 15),
                    child: const Text('Description:',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    width: 200,
                    height: 50,
                    margin: const EdgeInsets.only(right: 15),
                    color: Colors.white,
                    child: const TextField(),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 25, right: 15),
                    child: const Text('Icon:',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.white,
                    child: TextButton(
                      onPressed: () {
                        if (objectProvider.selectedIndex > -1
                            ? (objectProvider
                                    .objects[objectProvider.selectedIndex] !=
                                null)
                            : false) {
                          _pickIcon(context);
                        }
                      },
                      child: ((objectProvider.selectedIndex > -1
                              ? (objectProvider
                                      .objects[objectProvider.selectedIndex]
                                      .icon !=
                                  null)
                              : false)
                          ? Center(
                              child: objectProvider
                                  .objects[objectProvider.selectedIndex].icon,
                            )
                          : const Text(
                              'Select icon',
                            )),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              color: Colors.white,
              child: TextButton(
                onPressed: () {
                  Provider.of<MapObjectDataController>(context, listen: false)
                      .addObject(MapObjectData('Valami',
                          initSize: const Size(100, 100)));
                },
                child: const Text(
                  'Add new object',
                ),
              ),
            )
            // Container(
            //   margin: const EdgeInsets.only(top: 30),
            //   child: TextButton(
            //       onPressed: () {
            //         _displayTextInputDialog(context,
            //             title: 'Új térkép elem hozzáadása',
            //             hintText: 'Név',
            //             onSave: setSomeValue);
            //       },
            //       child: const Text('Új objektum hozzáadása',
            //           style: TextStyle(
            //               fontSize: 20,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.white))),
            // ),
            // SizedBox(
            //   height: 300,
            //   child: Center(
            //     child: Text(
            //       '$someValue',
            //       style: const TextStyle(fontSize: 50, color: Colors.white),
            //     ),
            //   ),
            // ),
          ],
        ),
        // child: Row(
        //   children: [
        //     Container(
        //       margin: const EdgeInsets.only(top: 30, left: 20),
        //       width: controllerWidth,
        //       child: Column(
        //         children: [
        //           Row(
        //             children: [
        //               Container(
        //                 alignment: Alignment.centerLeft,
        //                 child: Transform.rotate(
        //                   angle: -pi / 2,
        //                   child: IconButton(
        //                     onPressed: () {
        //                       Provider.of<MapObjectDataController>(context,
        //                               listen: false)
        //                           .rotateObject(60);
        //                     },
        //                     enableFeedback: true,
        //                     icon: const Icon(Icons.rotate_left),
        //                   ),
        //                 ),
        //               ),
        //               Container(
        //                 alignment: Alignment.centerRight,
        //                 child: Transform.rotate(
        //                   angle: pi / 2,
        //                   child: IconButton(
        //                     onPressed: () {
        //                       Provider.of<MapObjectDataController>(context,
        //                               listen: false)
        //                           .rotateObject(-60);
        //                     },
        //                     enableFeedback: true,
        //                     icon: const Icon(Icons.rotate_right),
        //                   ),
        //                 ),
        //               )
        //             ],
        //           ),
        //         ],
        //       ),
        //     ),
        //     Container(
        //       child: Column(
        //         children: [
        //           Container(
        //             margin: const EdgeInsets.only(top: 30, left: 20),
        //             child: IconButton(
        //               onPressed: () {
        //                 dev.log('add_object');
        //                 Provider.of<MapObjectDataController>(context,
        //                         listen: false)
        //                     .addObject(MapObjectData(
        //                   initSize: const Size(50, 50),
        //                 ));
        //               },
        //               enableFeedback: true,
        //               icon: const Icon(Icons.add),
        //             ),
        //           ),
        //           Container(
        //             margin: const EdgeInsets.only(top: 30, left: 20),
        //             child: IconButton(
        //               onPressed: () {
        //                 dev.log('save_object');
        //                 Provider.of<MapObjectDataController>(context,
        //                         listen: false)
        //                     .setMapSelected();
        //               },
        //               enableFeedback: true,
        //               icon: const Icon(Icons.add),
        //             ),
        //           ),
        //         ],
        //       ),
        //     )
        //   ],
        // ),
      ),
    );
  }
}
