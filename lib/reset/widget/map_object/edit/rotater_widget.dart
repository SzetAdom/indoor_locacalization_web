import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indoor_localization_web/reset/model/map_object/map_object_data_model.dart';

class RotaterWidget extends StatelessWidget {
  const RotaterWidget(
      {required this.mapObjectDataModel,
      required this.onRotate,
      this.size = const Size(20, 20),
      Key? key})
      : super(key: key);

  final MapObjectDataModel mapObjectDataModel;
  final Size size;
  final Function(double angle) onRotate;
  final double dragSensitivity = 2.2;
  final Offset distanceFromTop = const Offset(0, -30);

  Offset getOriginalPosition() {
    return Offset(0, mapObjectDataModel.getLocalEdgeInsets().top);
  }

  Offset rotate({required double x, required double y, required angle}) {
    var rotatedX = x * cos(angle) - y * sin(angle);
    var rotatedY = x * sin(angle) + y * cos(angle);
    return Offset(rotatedX, rotatedY);
  }

  Rect getRotator() {
    var edgePosition = getOriginalPosition();
    edgePosition = rotate(
        x: edgePosition.dx + distanceFromTop.dx,
        y: edgePosition.dy + distanceFromTop.dy,
        angle: mapObjectDataModel.angleInRadiant);

    edgePosition = mapObjectDataModel.toGlobalOffset(edgePosition);

    return Rect.fromCenter(
        center: edgePosition, width: size.width, height: size.height);
  }

  _panUpdate(DragUpdateDetails details) {
    var delta = details.delta;

    var alignmentVector =
        rotate(x: 0, y: -1, angle: mapObjectDataModel.angleInRadiant);

    alignmentVector = rotate(
        x: alignmentVector.dx, y: alignmentVector.dy, angle: 90 * (pi / 180));

    var component =
        (delta.dx * alignmentVector.dx + delta.dy * alignmentVector.dy) /
            (alignmentVector.dx * alignmentVector.dx +
                alignmentVector.dy * alignmentVector.dy);

    delta =
        Offset(component * alignmentVector.dx, component * alignmentVector.dy);

    var multiplier = 1;
    if (component < 0) {
      multiplier = -1;
    }

    double newAngle = mapObjectDataModel.angle + delta.distance * multiplier;

    if (RawKeyboard.instance.keysPressed
        .contains(LogicalKeyboardKey.controlLeft)) {
      if (newAngle > 0) {
        newAngle = (newAngle / 45).ceil() * 45;
      } else {
        newAngle = (newAngle / 45).floor() * 45;
      }
    }

    onRotate(newAngle);
  }

  void setToHorizontal() {
    onRotate(0);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: getRotator(),
      child: GestureDetector(
        onDoubleTap: setToHorizontal,
        dragStartBehavior: DragStartBehavior.down,
        onPanUpdate: _panUpdate,
        child: Container(
          decoration:
              const ShapeDecoration(shape: CircleBorder(), color: Colors.blue),
          child: Icon(
            Icons.rotate_left,
            color: Colors.white,
            size: size.width,
          ),
        ),
      ),
    );
  }
}
