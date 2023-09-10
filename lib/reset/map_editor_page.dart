import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indoor_localization_web/reset/map_editor_controller.dart';
import 'package:indoor_localization_web/reset/map_editor_painer.dart';
import 'package:provider/provider.dart';

class MapEditorPage extends StatefulWidget {
  const MapEditorPage({
    Key? key,
    required this.mapId,
  }) : super(key: key);

  final String mapId;

  @override
  State<MapEditorPage> createState() => _MapEditorPageResetState();
}

class _MapEditorPageResetState extends State<MapEditorPage> {
  late MapEditorController controller;

  late Future<bool> future;

  @override
  void initState() {
    super.initState();
    controller = MapEditorController();
    future = controller.loadMap(widget.mapId);
    ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  bool _onKey(KeyEvent event) {
    final key = event.logicalKey.keyLabel;

    if (event is KeyDownEvent) {
      if (key == 'Shift Left') {
        controller.selectMap(true);
      } else if (key == 'Control Left') {
        controller.setSnapToGrid(true);
      }
    } else if (event is KeyUpEvent) {
      if (key == 'Shift Left') {
        controller.selectMap(false);
      } else if (key == 'Control Left') {
        controller.setSnapToGrid(false);
      }
    }
    return false;
  }

  void onPointerScroll(PointerScrollEvent event) {
    if (event.scrollDelta.dy < 0) {
      controller.zoomIn(event.localPosition);
    } else {
      controller.zoomOut(event.localPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // controller.save();
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
      body: ChangeNotifierProvider<MapEditorController>(
        create: (context) => controller,
        child: Consumer<MapEditorController>(
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

                  return Listener(
                    onPointerSignal: (event) {
                      if (event is PointerScrollEvent) {
                        onPointerScroll(event);
                      }
                    },
                    child: Container(
                      color: Colors.blueGrey,
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // const MapEditorControlPanel(),
                                Expanded(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height,
                                    color: Colors.grey,
                                    child: GestureDetector(
                                      onTapDown: (details) => controller
                                          .onTap(details.localPosition),
                                      onPanStart: (details) => controller
                                          .onPanStart(details.localPosition),
                                      onPanUpdate: (details) =>
                                          controller.onPanUpdate(details),
                                      onPanEnd: (details) =>
                                          controller.onPanEnd(),
                                      child: ClipRect(
                                        clipBehavior: Clip.hardEdge,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: controller.map.width,
                                            maxHeight: controller.map.height,
                                          ),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              minWidth: controller.map.width,
                                              minHeight: controller.map.height,
                                            ),
                                            child: LayoutBuilder(
                                                builder: (context, constrains) {
                                              controller.canvasSize =
                                                  constrains.biggest;
                                              return CustomPaint(
                                                painter: MapEditorPainter(
                                                  map: controller.map,
                                                  selectedPointId: controller
                                                      .selectedPointId,
                                                  canvasOffset:
                                                      controller.canvasOffset,
                                                  gridStep: controller.gridStep,
                                                  mapSelected:
                                                      controller.mapSelected,
                                                  mapEditorPoints: controller
                                                      .mapEditorPoints,
                                                  selectedMapEditorPoint:
                                                      controller
                                                          .selectedMapEditorPoint,
                                                  zoomLevel:
                                                      controller.zoomLevel,
                                                  mapEditPointSize: controller
                                                      .mapEditPointSize,
                                                  pointSize:
                                                      controller.pointSize,
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Container(
                                //   width: 300,
                                //   color: Colors.blueGrey,
                                //   child: Column(children: [
                                //     const SizedBox(
                                //         height: 400, child: ObjectListWidget()),
                                //     GestureDetector(
                                //       child: Container(
                                //           child: const Text(
                                //         'Add object',
                                //         style: TextStyle(color: Colors.white),
                                //       )),
                                //     ),
                                //     IconButton(
                                //         color: Colors.white,
                                //         onPressed: () {},
                                //         icon: const Icon(Icons.add)),
                                //   ]),
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
