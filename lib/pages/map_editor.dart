import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:indoor_localization_web/providers/map_object_provider.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:provider/provider.dart';

class MapEditor extends StatefulWidget {
  MapEditor({required this.width, required this.height, Key? key})
      : super(key: key);
  double width;
  double height;

  @override
  State<MapEditor> createState() => _MapEditorState();
}

class _MapEditorState extends State<MapEditor> {
  final bool _doneBuilding = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    //   // setState(() {
    //   //   _doneBuilding = true;
    //   // });
    // });
  }

  Matrix4 matrix = Matrix4.identity();
  ValueNotifier<int> notifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    var mapObjectController = Provider.of<MapObjectProvider>(context);
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (ctx, constraints) {
                  return MatrixGestureDetector(
                    shouldRotate: false,
                    shouldScale: false,
                    shouldTranslate: mapObjectController.mapSelected,
                    onMatrixUpdate: (m, tm, sm, rm) {
                      matrix =
                          MatrixGestureDetector.compose(matrix, tm, sm, null);

                      notifier.value++;
                    },
                    child: GestureDetector(
                      onTap: () {
                        mapObjectController.setMapSelected();
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
                                  width: widget.width,
                                  height: widget.height,
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
                                          // if (_doneBuilding)
                                          ...mapObjectController.objects
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
        MapObjectControlPanel(
          refreshMap: () {
            notifier.value++;
          },
        ),
      ],
    );
  }
}

class MapObjectControlPanel extends StatefulWidget {
  MapObjectControlPanel({required this.refreshMap, Key? key}) : super(key: key);

  Function refreshMap;

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
    final TextEditingController textFieldController = TextEditingController();
    textFieldController.text = defaultValue;

    void _onSave(BuildContext context) {
      if (textFieldController.text != '') {
        setState(() {
          onSave(textFieldController.text);
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
              controller: textFieldController,
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
    try {
      IconData? icon = await FlutterIconPicker.showIconPicker(
        context,
      );

      if (icon != null) {
        Provider.of<MapObjectProvider>(context, listen: false)
            .addIcon(Icon(icon));
        setState(() {});
      }
    } catch (e) {
      dev.log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<MapObjectProvider>(context, listen: false).addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var objectProvider = Provider.of<MapObjectProvider>(context);
    return SingleChildScrollView(
      child: Container(
        color: Colors.blueGrey,
        width: 400,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 56),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                        if (!objectProvider
                            .objects[index].controller.selected) {
                          objectProvider.setSelected(index, notifyWidget: true);
                        } else {
                          objectProvider.setMapSelected();
                        }
                      },
                      child: Container(
                        height: 30,
                        color: objectProvider.objects[index].controller.selected
                            ? Colors.grey.shade400
                            : Colors.white,
                        child: Text(
                          objectProvider.objects[index].controller.name,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                child: Center(
                    child: Text(
                  objectProvider.objects.length.toString(),
                  style: const TextStyle(fontSize: 30),
                )),
              ),
              DataField(
                title: 'Name',
                value: objectProvider.getSelected()?.name ?? '',
                onChanged: objectProvider.setName,
                width: 250,
              ),
              DataField(
                title: 'Description',
                value: objectProvider.getSelected()?.description ?? '',
                onChanged: objectProvider.setDescription,
                height: 100,
                width: 250,
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 25, right: 55),
                      child: const Text('Icon:',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.white,
                      child: TextButton(
                        onPressed: () {
                          if (objectProvider.getSelected() != null) {
                            _pickIcon(context);
                          }
                        },
                        child: ((objectProvider.getSelected()?.icon != null)
                            ? Center(
                                child: objectProvider.getSelected()?.icon,
                              )
                            : const Text(
                                'Select icon',
                              )),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        DataField<double>(
                          title: 'Width',
                          value: '${objectProvider.getSelected()?.width ?? ''}',
                          onChanged: objectProvider.setWidth,
                          doubleOnly: true,
                        ),
                        DataField<double>(
                          title: 'Height',
                          value:
                              '${objectProvider.getSelected()?.height ?? ''}',
                          onChanged: objectProvider.setHeight,
                          doubleOnly: true,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        DataField<double>(
                          title: 'X',
                          value: '${objectProvider.getSelected()?.x ?? ''}',
                          onChanged: objectProvider.setX,
                          doubleOnly: true,
                        ),
                        DataField(
                          title: 'Y',
                          value: '${objectProvider.getSelected()?.y ?? ''}',
                          onChanged: objectProvider.setY,
                          doubleOnly: true,
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
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      child: Slider(
                        thumbColor: Colors.white,
                        min: -90,
                        max: 90,
                        activeColor: Colors.grey,
                        inactiveColor: Colors.grey,
                        onChanged: (value) => {
                          setState(() {
                            objectProvider.rotateObject(value);
                          })
                        },
                        divisions: 180,
                        label:
                            '${(objectProvider.getSelected()?.angle ?? 0).toStringAsFixed(0)}°',
                        value: objectProvider.getSelected()?.angle ?? 0,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30, bottom: 30),
                color: Colors.white,
                child: TextButton(
                  onPressed: () {
                    if (objectProvider.selectedIndex == -1) {
                      objectProvider.addObject();
                    } else {
                      objectProvider.removeObject();
                      setState(() {});
                      widget.refreshMap();
                    }
                  },
                  child: Text(
                    objectProvider.selectedIndex == -1
                        ? 'Add new object'
                        : 'Remove object',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DataField<T> extends StatelessWidget {
  DataField({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.width = 70,
    this.height = 50,
    this.doubleOnly = false,
    this.alignment = MainAxisAlignment.end,
  }) : super(key: key);

  final String title;
  final String value;
  final Function(T value) onChanged;
  bool doubleOnly = false;
  double width;
  double height;
  MainAxisAlignment alignment;

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _textController.text = value;
    return Row(
      mainAxisAlignment: alignment,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15, right: 15),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15, right: 40),
          color: Colors.white,
          width: width,
          height: height,
          child: TextField(
              maxLines: 10,
              style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.number,
              controller: _textController,
              onChanged: (value) {
                if (doubleOnly) {
                  onChanged(double.parse(value) as T);
                } else {
                  onChanged(value as T);
                }
              },
              onSubmitted: (value) {
                Provider.of<MapObjectProvider>(context, listen: false).notify();
              },
              inputFormatters: doubleOnly
                  ? [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))]
                  : []),
        ),
      ],
    );
  }
}
