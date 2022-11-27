import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/model/map_object/map_object_data_model.dart';
import 'package:indoor_localization_web/reset/model/map_object/map_object_model.dart';
import 'package:indoor_localization_web/reset/widget/map_object/edit/rotater_widget.dart';
import 'package:indoor_localization_web/reset/widget/map_object/edit/sizer_widget.dart';
import 'package:indoor_localization_web/reset/widget/map_object/map_object_widget.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class MapObjectEditorWidget extends StatefulWidget {
  const MapObjectEditorWidget(this.mapObjectModel,
      {required this.saveCallback,
      required this.selectedCallback,
      this.selected = false,
      Key? key})
      : super(key: key);

  final MapObjectModel mapObjectModel;
  final Future<void> Function(MapObjectDataModel mapObjectDataModel)
      saveCallback;
  final Function(bool selected) selectedCallback;
  final bool selected;
  final Size _minSize = const Size(20, 20);

  @override
  State<MapObjectEditorWidget> createState() => _MapObjectEditorWidgetState();
}

class _MapObjectEditorWidgetState extends State<MapObjectEditorWidget>
    with TickerProviderStateMixin {
  late ValueNotifier<MapObjectDataModel> mapObjectDataModel;

  final GlobalKey stackKey = GlobalKey();

  void save() async {
    await widget.saveCallback.call(mapObjectDataModel.value);
  }

  void resize(MapObjectDataModel newModel) {
    if (newModel.width < widget._minSize.width ||
        newModel.height < widget._minSize.height) {
      return;
    }
    // bool outOfBounds = false;
    // if (newModel.width < widget._minSize.width) {
    //   newModel.width = widget._minSize.width;
    //   outOfBounds = true;
    // }
    // if (newModel.height < widget._minSize.height) {
    //   newModel.height = widget._minSize.height;
    //   outOfBounds = true;
    // }
    // if (outOfBounds) {
    //   newModel.x = mapObjectDataModel.value.x;
    //   newModel.y = mapObjectDataModel.value.y;
    // }
    mapObjectDataModel.value = newModel;
    setState(() {});
  }

  void rotate(double angle) {
    mapObjectDataModel.value = mapObjectDataModel.value.copyWith(angle: angle);
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
              shouldTranslate: widget.selected && true,
              shouldScale: false,
              shouldRotate: false,
              focalPointAlignment: Alignment.center,
              child: Stack(
                key: stackKey,
                children: [
                  MapObjecWidget(
                    widget.mapObjectModel.cloneWith(mapObjectDataModel.value),
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
                        mapObjectDataModel: mapObjectDataModel.value,
                        onRotate: rotate),
                  if (widget.selected)
                    SizerWidget(
                        mapObjectDataModel: mapObjectDataModel.value,
                        alignment: Alignment.topLeft,
                        onResize: resize),
                  if (widget.selected)
                    SizerWidget(
                        mapObjectDataModel: mapObjectDataModel.value,
                        alignment: Alignment.topRight,
                        onResize: resize),
                  if (widget.selected)
                    SizerWidget(
                        mapObjectDataModel: mapObjectDataModel.value,
                        alignment: Alignment.bottomLeft,
                        onResize: resize),
                  if (widget.selected)
                    SizerWidget(
                        mapObjectDataModel: mapObjectDataModel.value,
                        alignment: Alignment.bottomRight,
                        onResize: resize),
                  if (widget.selected)
                    SizerWidget(
                        mapObjectDataModel: mapObjectDataModel.value,
                        alignment: Alignment.topCenter,
                        onResize: resize),
                  if (widget.selected)
                    SizerWidget(
                        mapObjectDataModel: mapObjectDataModel.value,
                        alignment: Alignment.bottomCenter,
                        onResize: resize),
                  if (widget.selected)
                    SizerWidget(
                        mapObjectDataModel: mapObjectDataModel.value,
                        alignment: Alignment.centerLeft,
                        onResize: resize),
                  if (widget.selected)
                    SizerWidget(
                        mapObjectDataModel: mapObjectDataModel.value,
                        alignment: Alignment.centerRight,
                        onResize: resize),
                ],
              ));
        });
  }
}
