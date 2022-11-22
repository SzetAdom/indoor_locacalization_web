import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_object_widget.dart';
import 'package:indoor_localization_web/reset/model/map_object_metadata.dart';
import 'package:indoor_localization_web/reset/model/map_object_model.dart';
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
  final GlobalKey _key = GlobalKey();

  void save() async {
    await widget.saveCallback.call(mapObjectDataModel.value);
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
                log(newMatrix.getTranslation().x.toString());
                mapObjectDataModel.value.moveByMatrix4(newMatrix);
                log(mapObjectDataModel.value.toString());
                setState(() {});
              },
              clipChild: true,
              shouldTranslate: selected && true,
              shouldScale: false,
              shouldRotate: false,
              focalPointAlignment: Alignment.center,
              child: Container(
                // color: Colors.green,
                child: Stack(
                  key: _key,
                  children: [
                    MapObjecWidget(
                      widget.mapObjectModel.cloneWith(mapObjectDataModel.value),
                      child: (Widget mapObjectWidget) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = !selected;
                              widget.selectedCallback.call();
                              log(mapObjectDataModel.value.toString());
                            });
                          },
                          child: mapObjectWidget,
                        );
                      },
                    ),
                  ],
                ),
              ));
        });
  }
}
