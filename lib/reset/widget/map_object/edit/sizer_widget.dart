import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/model/map_object/map_object_data_model.dart';

class SizerWidget extends StatelessWidget {
  const SizerWidget(
      {required this.mapObjectDataModel,
      required this.alignment,
      required this.onResize,
      this.size = const Size(10, 10),
      Key? key})
      : super(key: key);

  /// The map object data model
  final MapObjectDataModel mapObjectDataModel;

  /// The size of the sizer
  final Size size;

  /// The alignment of the sizer, relative to the map object
  final Alignment alignment;

  /// The callback function when the sizer is resized
  final Function(MapObjectDataModel mapObjectDataModel) onResize;

  /// The sensitivity of the drag
  final double dragSensitivity = 2.2;

  /// Rotate a point (helper function)
  Offset _rotate({required double x, required double y, required angle}) {
    var rotatedX = x * cos(angle) - y * sin(angle);
    var rotatedY = x * sin(angle) + y * cos(angle);
    return Offset(rotatedX, rotatedY);
  }

  /// The position of the sizer relative to the center of the map object withouth rotation
  Offset _getOriginalPosition() {
    var originalEdgeinsets = mapObjectDataModel.getLocalEdgeInsets();
    if (alignment == Alignment.topLeft) {
      return Offset(originalEdgeinsets.left, originalEdgeinsets.top);
    } else if (alignment == Alignment.topRight) {
      return Offset(originalEdgeinsets.right, originalEdgeinsets.top);
    } else if (alignment == Alignment.bottomLeft) {
      return Offset(originalEdgeinsets.left, originalEdgeinsets.bottom);
    } else if (alignment == Alignment.bottomRight) {
      return Offset(originalEdgeinsets.right, originalEdgeinsets.bottom);
    } else if (alignment == Alignment.topCenter) {
      return Offset(0, originalEdgeinsets.top);
    } else if (alignment == Alignment.bottomCenter) {
      return Offset(0, originalEdgeinsets.bottom);
    } else if (alignment == Alignment.centerLeft) {
      return Offset(originalEdgeinsets.left, 0);
    } else if (alignment == Alignment.centerRight) {
      return Offset(originalEdgeinsets.right, 0);
    } else if (alignment == Alignment.center) {
      return const Offset(0, 0);
    }
    return Offset.zero;
  }

  /// Get the global (relative to the map top left corner) position of the sizer
  Rect _getSizer() {
    var edgePosition = _getOriginalPosition();

    edgePosition = _rotate(
        x: edgePosition.dx,
        y: edgePosition.dy,
        angle: mapObjectDataModel.angleInRadiant);

    edgePosition = mapObjectDataModel.toGlobalOffset(edgePosition);

    return Rect.fromCenter(
        center: edgePosition, width: size.width, height: size.height);
  }

  /// Resize the map object when the sizer is dragged
  _panUpdate(DragUpdateDetails details) {
    ///Vector of the drag gesture in the local coordinate system
    var delta = details.delta;

    ///Filter the drag vector to the direction of the sizer, only when sides are dragged
    if (alignment.x == 0 || alignment.y == 0) {
      var alignmentVector = _rotate(
          x: alignment.x,
          y: alignment.y,
          angle: mapObjectDataModel.angleInRadiant);

      var projection =
          (delta.dx * alignmentVector.dx + delta.dy * alignmentVector.dy) /
              (alignmentVector.dx * alignmentVector.dx +
                  alignmentVector.dy * alignmentVector.dy);
      delta = Offset(
          projection * alignmentVector.dx, projection * alignmentVector.dy);
    }

    ///Remove the rotaion of the drag (the size change must be calculated without rotation)
    var rotatedDelta = _rotate(
        x: delta.dx, y: delta.dy, angle: -mapObjectDataModel.angleInRadiant);

    ///Calculate the new size of the map object
    var newX = mapObjectDataModel.x + (delta.dx / 2 * dragSensitivity);
    var newY = mapObjectDataModel.y + (delta.dy / 2 * dragSensitivity);

    var newWidth = mapObjectDataModel.width +
        (rotatedDelta.dx * alignment.x * dragSensitivity);
    var newHeight = mapObjectDataModel.height +
        (rotatedDelta.dy * alignment.y * dragSensitivity);
    var newMapObjectData = MapObjectDataModel(
        x: newX,
        y: newY,
        width: newWidth,
        height: newHeight,
        angle: mapObjectDataModel.angle);

    ///Update the map object
    onResize(newMapObjectData);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: _getSizer(),
      child: GestureDetector(
        dragStartBehavior: DragStartBehavior.down,
        onPanUpdate: _panUpdate,
        child: Container(
          decoration:
              const ShapeDecoration(shape: CircleBorder(), color: Colors.blue),
        ),
      ),
    );
  }
}
