import 'package:flutter/material.dart';
import 'package:indoor_localization_web/model/map_object/map_object_data_model.dart';
import 'package:indoor_localization_web/model/map_object/map_object_model.dart';
import 'package:indoor_localization_web/settings.dart';
import 'package:indoor_localization_web/widget/map_object/edit/rotater_widget.dart';
import 'package:indoor_localization_web/widget/map_object/edit/sizer_widget.dart';
import 'package:indoor_localization_web/widget/map_object/map_object_widget.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class MapObjectEditorWidget extends StatefulWidget {
  const MapObjectEditorWidget(this.mapObjectModel,
      {required this.selectedCallback,
      required this.onChange,
      this.selected = false,
      Key? key})
      : super(key: key);

  final MapObjectModel mapObjectModel;
  final Function(bool selected) selectedCallback;
  final Function(MapObjectModel newModel) onChange;
  final bool selected;

  @override
  State<MapObjectEditorWidget> createState() => _MapObjectEditorWidgetState();
}

class _MapObjectEditorWidgetState extends State<MapObjectEditorWidget>
    with TickerProviderStateMixin {
  late MapObjectDataModel mapObjectDataModel;

  final GlobalKey stackKey = GlobalKey();

  void resize(MapObjectDataModel newModel) {
    if (newModel.width < minSize.width || newModel.height < minSize.height) {
      return;
    }
    mapObjectDataModel = newModel;

    widget.onChange(widget.mapObjectModel.copyWith(data: mapObjectDataModel));
    setState(() {});
  }

  void rotate(double angle) {
    mapObjectDataModel = mapObjectDataModel.copyWith(angle: angle);
    widget.onChange(widget.mapObjectModel.copyWith(data: mapObjectDataModel));
    setState(() {});
  }

  void onMove() {
    widget.onChange(widget.mapObjectModel.copyWith(data: mapObjectDataModel));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mapObjectDataModel = widget.mapObjectModel.data;
    return MatrixGestureDetector(
        onMatrixUpdate: (m, tm, sm, rm) {
          var newMatrix = MatrixGestureDetector.compose(
              mapObjectDataModel.matrix, tm, sm, rm);

          mapObjectDataModel.moveByMatrix4(newMatrix);
          onMove();
        },
        clipChild: true,
        shouldTranslate: widget.selected && true,
        shouldScale: false,
        shouldRotate: false,
        focalPointAlignment: Alignment.center,
        child: Stack(
          key: stackKey,
          children: [
            MapObjecWidget(
              widget.mapObjectModel.copyWith(data: mapObjectDataModel),
              child: (Widget mapObjectWidget) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: widget.selected
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2)),
                  child: GestureDetector(
                    onTap: () {
                      widget.selectedCallback.call(!widget.selected);
                    },
                    child: mapObjectWidget,
                  ),
                );
              },
            ),
            if (widget.selected)
              RotaterWidget(
                  mapObjectDataModel: mapObjectDataModel, onRotate: rotate),
            if (widget.selected)
              SizerWidget(
                  mapObjectDataModel: mapObjectDataModel,
                  alignment: Alignment.topLeft,
                  onResize: resize),
            if (widget.selected)
              SizerWidget(
                  mapObjectDataModel: mapObjectDataModel,
                  alignment: Alignment.topRight,
                  onResize: resize),
            if (widget.selected)
              SizerWidget(
                  mapObjectDataModel: mapObjectDataModel,
                  alignment: Alignment.bottomLeft,
                  onResize: resize),
            if (widget.selected)
              SizerWidget(
                  mapObjectDataModel: mapObjectDataModel,
                  alignment: Alignment.bottomRight,
                  onResize: resize),
            if (widget.selected)
              SizerWidget(
                  mapObjectDataModel: mapObjectDataModel,
                  alignment: Alignment.topCenter,
                  onResize: resize),
            if (widget.selected)
              SizerWidget(
                  mapObjectDataModel: mapObjectDataModel,
                  alignment: Alignment.bottomCenter,
                  onResize: resize),
            if (widget.selected)
              SizerWidget(
                  mapObjectDataModel: mapObjectDataModel,
                  alignment: Alignment.centerLeft,
                  onResize: resize),
            if (widget.selected)
              SizerWidget(
                  mapObjectDataModel: mapObjectDataModel,
                  alignment: Alignment.centerRight,
                  onResize: resize),
          ],
        ));
  }
}
