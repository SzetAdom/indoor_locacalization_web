import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_object_editor_widget.dart';
import 'package:indoor_localization_web/reset/model/map_object_metadata.dart';
import 'package:indoor_localization_web/reset/model/map_object_model.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class MapEditorPage extends StatefulWidget {
  const MapEditorPage({Key? key}) : super(key: key);

  final double width = 500;
  final double height = 500;

  @override
  State<MapEditorPage> createState() => _MapEditorPageState();
}

class _MapEditorPageState extends State<MapEditorPage> {
  Matrix4 matrix = Matrix4.identity();
  ValueNotifier<int> notifier = ValueNotifier(0);

  bool mapSelected = true;

  List<MapObjectEditorWidget> mapObjects = [];

  @override
  void initState() {
    // TODO: implement initState

    mapObjects.add(MapObjectEditorWidget(
      MapObjectModel(
        id: '1',
        color: Colors.grey,
        name: 'Object 1',
        description: 'Object 1 description',
        icon: const Icon(Icons.ac_unit),
        data: MapObjectDataModel(
          x: 100,
          y: 100,
          width: 100,
          height: 100,
          angle: 0,
        ),
      ),
      selectedCallback: () {
        setState(() {
          mapSelected = false;
        });
      },
      saveCallback: (mapObjectModel) async {},
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var _mapObjectController = Provider.of<MapObjectProvider>(context);
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

                    ///TODO:with controller
                    shouldTranslate: mapSelected,
                    onMatrixUpdate: (m, tm, sm, rm) {
                      matrix =
                          MatrixGestureDetector.compose(matrix, tm, sm, null);

                      notifier.value++;
                    },
                    child: GestureDetector(
                      onTap: () {
                        ///TODO: with controleler
                        setState(() {
                          mapSelected = true;
                        });
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
                                        children: mapObjects,
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
        )
      ],
    );
  }
}
