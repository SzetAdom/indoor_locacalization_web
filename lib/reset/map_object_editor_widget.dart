import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_object_widget.dart';
import 'package:indoor_localization_web/reset/model/map_object_metadata.dart';
import 'package:indoor_localization_web/reset/model/map_object_model.dart';
import 'package:indoor_localization_web/reset/sizer_widget.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class MapObjectEditorWidget extends StatefulWidget {
  const MapObjectEditorWidget(this.mapObjectModel,
      {required this.saveCallback, required this.selectedCallback, Key? key})
      : super(key: key);

  final MapObjectModel mapObjectModel;
  final Future<void> Function(MapObjectDataModel mapObjectDataModel)
      saveCallback;
  final Function selectedCallback;

  @override
  State<MapObjectEditorWidget> createState() => _MapObjectEditorWidgetState();
}

class _MapObjectEditorWidgetState extends State<MapObjectEditorWidget>
    with TickerProviderStateMixin {
  late ValueNotifier<MapObjectDataModel> mapObjectDataModel;
  bool selected = false;
  final GlobalKey stackKey = GlobalKey();

  void save() async {
    await widget.saveCallback.call(mapObjectDataModel.value);
  }

  void resize(MapObjectDataModel mapObjectDataModel) {
    this.mapObjectDataModel.value = mapObjectDataModel;
    setState(() {});
  }

  @override
  void initState() {
    mapObjectDataModel = ValueNotifier(widget.mapObjectModel.data);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([mapObjectDataModel]),
        builder: (context, child) {
          return MatrixGestureDetector(
              onMatrixUpdate: (m, tm, sm, rm) {
                var newMatrix = MatrixGestureDetector.compose(
                    mapObjectDataModel.value.matrix, tm, sm, rm);

                mapObjectDataModel.value.moveByMatrix4(newMatrix);

                setState(() {});
              },
              clipChild: true,
              shouldTranslate: selected && true,
              shouldScale: false,
              shouldRotate: false,
              focalPointAlignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: selected ? Colors.blue : Colors.transparent)),
                child: Stack(
                  key: stackKey,
                  children: [
                    MapObjecWidget(
                      widget.mapObjectModel.cloneWith(mapObjectDataModel.value),
                      child: (Widget mapObjectWidget) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = !selected;
                              log('selected: $selected');
                              widget.selectedCallback.call();
                            });
                          },
                          child: mapObjectWidget,
                        );
                      },
                    ),
                    SizerWidget(
                      mapObjectDataModel: mapObjectDataModel.value,
                      alignment: Alignment.topLeft,
                      onResize: resize,
                      stackKey: stackKey,
                    ),
                    SizerWidget(
                      mapObjectDataModel: mapObjectDataModel.value,
                      alignment: Alignment.topRight,
                      onResize: resize,
                      stackKey: stackKey,
                    ),
                    SizerWidget(
                      mapObjectDataModel: mapObjectDataModel.value,
                      alignment: Alignment.bottomLeft,
                      onResize: resize,
                      stackKey: stackKey,
                    ),
                    SizerWidget(
                      mapObjectDataModel: mapObjectDataModel.value,
                      alignment: Alignment.bottomRight,
                      onResize: resize,
                      stackKey: stackKey,
                    ),
                  ],
                ),
              ));
        });
  }
}
