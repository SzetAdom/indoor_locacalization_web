import 'dart:developer';
import 'dart:html';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indoor_localization_web/controller/map_object_editor_controller.dart';
import 'package:indoor_localization_web/widget/map_editor/map_editor_control_panel.dart';
import 'package:indoor_localization_web/widgets/object_list_widget.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:provider/provider.dart';

class MapEditorPageOld extends StatefulWidget {
  const MapEditorPageOld({required this.mapId, Key? key}) : super(key: key);
  @override
  State<MapEditorPageOld> createState() => _MapEditorPageOldState();

  final String mapId;
}

class _MapEditorPageOldState extends State<MapEditorPageOld> {
  Matrix4 matrix = Matrix4.identity();
  ValueNotifier<int> notifier = ValueNotifier(0);
  late MapObjectEditorController controller;
  Future? future;

  String? mapId;

  @override
  void initState() {
    // TODO: implement initState
    log('initState');
    controller = MapObjectEditorController();
    controller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  void loadMapId(BuildContext context) {
    try {
      mapId ??= (ModalRoute.of(context)?.settings.arguments ?? '') as String;
      if (mapId != '') {
        Storage localStorage = window.localStorage;
        localStorage['mapId'] = mapId!;
      } else {
        Storage localStorage = window.localStorage;
        mapId = localStorage['mapId'];
      }
    } catch (e) {
      log(e.toString());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    loadMapId(context);
    future ??= controller.init(mapId!);
    // var _mapObjectController = Provider.of<MapObjectProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              controller.save();
            },
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: () {
              // controller.undo();
            },
            icon: const Icon(Icons.undo),
          ),
          IconButton(
            onPressed: () {
              // controller.redo();
            },
            icon: const Icon(Icons.redo),
          ),
        ],
      ),
      body: ChangeNotifierProvider<MapObjectEditorController>(
        create: (context) => controller,
        child: Consumer<MapObjectEditorController>(
          builder: (context, value, child) => FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (!snapshot.hasData ||
                      (snapshot.hasData && snapshot.data == false)) {
                    return Container(
                      child: const Text('Hiba történt betöltés közben'),
                    );
                  }

                  return Row(
                    children: [
                      const MapEditorControlPanel(),
                      Expanded(
                        child: Listener(
                          onPointerSignal: (event) {
                            if (event is PointerScrollEvent &&
                                RawKeyboard.instance.keysPressed
                                    .contains(LogicalKeyboardKey.controlLeft)) {
                              if (event.scrollDelta.dy < 0) {
                                matrix = matrix.scaled(1.1);
                                controller.changeScale(controller.scale * 1.1);
                              } else {
                                matrix = matrix.scaled(1 / 1.1);
                                controller.changeScale(controller.scale / 1.1);
                              }

                              notifier.value++;
                            }
                          },
                          child: Container(
                            child: Stack(
                              children: [
                                LayoutBuilder(
                                  builder: (ctx, constraints) {
                                    return MatrixGestureDetector(
                                      shouldRotate: false,
                                      shouldScale: false,
                                      shouldTranslate: value.mapSelected,
                                      onMatrixUpdate: (m, tm, sm, rm) {
                                        matrix = MatrixGestureDetector.compose(
                                            matrix, tm, sm, null);

                                        notifier.value++;
                                      },
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.selectObject(-1, true);
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
                                                    width: controller
                                                        .mapDataModel.width,
                                                    height: controller
                                                        .mapDataModel.height,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                    ),
                                                    child: Container(
                                                      color:
                                                          Colors.grey.shade200,
                                                      child: GridPaper(
                                                        color: Colors.black,
                                                        child: Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            for (int i = 0;
                                                                i <
                                                                    controller
                                                                        .mapDataModel
                                                                        .objects
                                                                        .length;
                                                                i++)
                                                              controller
                                                                  .getEditWidget(
                                                                      i)
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
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        color: Colors.blueGrey,
                        child: Column(children: [
                          const SizedBox(
                              height: 400, child: ObjectListWidget()),
                          GestureDetector(
                            child: Container(
                                child: const Text(
                              'Add object',
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                          IconButton(
                              color: Colors.white,
                              onPressed: Provider.of<MapObjectEditorController>(
                                      context,
                                      listen: false)
                                  .addObject,
                              icon: const Icon(Icons.add)),
                        ]),
                      )
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
