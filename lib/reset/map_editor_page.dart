import 'package:flutter/material.dart';
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

                  return Container(
                    color: Colors.blueGrey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // const MapEditorControlPanel(),
                              GestureDetector(
                                onTapDown: (details) =>
                                    controller.onTap(details.localPosition),
                                onPanStart: (details) => controller
                                    .onPanStart(details.localPosition),
                                onPanUpdate: (details) =>
                                    controller.onPanUpdate(details),
                                onPanEnd: (details) => controller.onPanEnd(),
                                child: ClipRect(
                                  clipBehavior: Clip.hardEdge,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: controller.map.width,
                                      minHeight: controller.map.height,
                                    ),
                                    child: CustomPaint(
                                      painter: MapEditorPainter(
                                        points: controller.map.points,
                                        selectedPointId:
                                            controller.selectedPointId,
                                        mapOffset: controller.mapOffset,
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
