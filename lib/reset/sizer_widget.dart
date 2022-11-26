import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/model/map_object_metadata.dart';

class SizerWidget extends StatelessWidget {
  const SizerWidget(
      {required this.mapObjectDataModel,
      required this.alignment,
      required this.onResize,
      this.size = const Size(10, 10),
      Key? key})
      : super(key: key);

  final MapObjectDataModel mapObjectDataModel;
  final Size size;
  final Alignment alignment;
  final Function(MapObjectDataModel mapObjectDataModel) onResize;
  final double dragSensitivity = 2.2;

  Offset getAlignMultipliers() {
    var x = 0.0;
    var y = 0.0;
    if (alignment == Alignment.topLeft) {
      x = -1;
      y = -1;
    } else if (alignment == Alignment.topRight) {
      x = 1;
      y = -1;
    } else if (alignment == Alignment.bottomLeft) {
      x = -1;
      y = 1;
    } else if (alignment == Alignment.bottomRight) {
      x = 1;
      y = 1;
    } else if (alignment == Alignment.topCenter) {
      x = 0;
      y = -1;
    } else if (alignment == Alignment.bottomCenter) {
      x = 0;
      y = 1;
    } else if (alignment == Alignment.centerLeft) {
      x = -1;
      y = 0;
    } else if (alignment == Alignment.centerRight) {
      x = 1;
      y = 0;
    } else if (alignment == Alignment.center) {
      x = 0;
      y = 0;
    }
    return Offset(x, y);
  }

  Offset getOriginalPosition() {
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

  Offset rotate({required double x, required double y, required angle}) {
    var rotatedX = x * cos(angle) - y * sin(angle);
    var rotatedY = x * sin(angle) + y * cos(angle);
    return Offset(rotatedX, rotatedY);
  }

  Rect getSizer() {
    var edgePosition = getOriginalPosition();

    edgePosition = rotate(
        x: edgePosition.dx,
        y: edgePosition.dy,
        angle: mapObjectDataModel.angleInRadiant);

    edgePosition = mapObjectDataModel.toGlobalOffset(edgePosition);

    return Rect.fromCenter(
        center: edgePosition, width: size.width, height: size.height);
  }

  _panStart(DragStartDetails details) {
    dev.log('drag started');
  }

  _panUpdate(DragUpdateDetails details) {
    var delta = details.delta;

    dev.log('delta: $delta');

    if (getAlignMultipliers().dx == 0 || getAlignMultipliers().dy == 0) {
      var alignmentVector = rotate(
          x: getAlignMultipliers().dx,
          y: getAlignMultipliers().dy,
          angle: mapObjectDataModel.angleInRadiant);

      var component =
          (delta.dx * alignmentVector.dx + delta.dy * alignmentVector.dy) /
              (alignmentVector.dx * alignmentVector.dx +
                  alignmentVector.dy * alignmentVector.dy);
      delta = Offset(
          component * alignmentVector.dx, component * alignmentVector.dy);
    }

    var rotatedDelta = rotate(
        x: delta.dx, y: delta.dy, angle: -mapObjectDataModel.angleInRadiant);

    var newX = mapObjectDataModel.x + (delta.dx / 2 * dragSensitivity);
    var newY = mapObjectDataModel.y + (delta.dy / 2 * dragSensitivity);

    var newWidth = mapObjectDataModel.width +
        (rotatedDelta.dx * getAlignMultipliers().dx * dragSensitivity);
    var newHeight = mapObjectDataModel.height +
        (rotatedDelta.dy * getAlignMultipliers().dy * dragSensitivity);
    var newMapObjectData = MapObjectDataModel(
        x: newX,
        y: newY,
        width: newWidth,
        height: newHeight,
        angle: mapObjectDataModel.angle);
    onResize(newMapObjectData);
  }

  _panEnd(DragEndDetails details) {
    dev.log('drag ended');
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: getSizer(),
      child: GestureDetector(
        dragStartBehavior: DragStartBehavior.down,
        onPanStart: (details) => _panStart(details),
        onPanUpdate: _panUpdate,
        onPanEnd: _panEnd,
        child: Container(
          decoration:
              const ShapeDecoration(shape: CircleBorder(), color: Colors.blue),
        ),
      ),
    );
  }
}
