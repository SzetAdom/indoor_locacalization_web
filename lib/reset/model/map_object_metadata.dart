import 'dart:math';

import 'package:flutter/material.dart';

class MapObjectDataModel {
  double x;
  double y;
  double width;
  double height;
  double angle;

  MapObjectDataModel(
      {required this.x,
      required this.y,
      required this.width,
      required this.height,
      required this.angle});

  Rect get rect => Rect.fromCenter(
        center: Offset(x, y),
        width: width,
        height: height,
      );

  double get angleInRadiant => (angle * (pi / 180));

  Offset get localCenter => Offset(x, y);

  EdgeInsets get localEdgeInsets => EdgeInsets.fromLTRB(
      x - (width / 2), y - (height / 2), x + (width / 2), y + (height / 2));

  Rect get localRect => Rect.fromCenter(
        center: Offset(x, y),
        width: width,
        height: height,
      );

  Offset get center => rect.center;

  Matrix4 get matrix => Matrix4.identity()..translate(x, y);

  moveByMatrix4(Matrix4? matrix4) {
    if (matrix4 == null) return;

    var translationVector = matrix4.getTranslation();
    x = translationVector.x;
    y = translationVector.y;
  }

  EdgeInsets get edgeInsets =>
      EdgeInsets.fromLTRB(rect.left, rect.top, rect.right, rect.bottom);

  void resizeByRect(Rect rect) {
    x = rect.center.dx;
    y = rect.center.dy;
    width = rect.width;
    height = rect.height;
  }

  @override
  String toString() {
    return 'MapObjectDataModel(x: $x, y: $y, width: $width, height: $height, angle: $angle)';
  }
}
