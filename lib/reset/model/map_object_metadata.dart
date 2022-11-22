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

  Offset get center => rect.center;

  Matrix4 get matrix => Matrix4.identity()..translate(x, y);

  moveByMatrix4(Matrix4? matrix4) {
    if (matrix4 == null) return;

    var translationVector = matrix4.getTranslation();
    // dev.log(translationVector.x.toString());
    // dev.log(translationVector.y.toString());
    // Offset newOffset =
    //     center.translate(translationVector.x, translationVector.y);
    x = translationVector.x;
    y = translationVector.y;
  }

  @override
  String toString() {
    return 'MapObjectDataModel(x: $x, y: $y, width: $width, height: $height, angle: $angle)';
  }
}
