import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_helper.dart';

class DoorModel {
  int firstPointIndex;
  int secontPointIndex;

  double distanceToFirstPoint;
  double distanceToSecondPoint;

  List<int> get pointsIndexes => [firstPointIndex, secontPointIndex];

  DoorModel({
    required this.firstPointIndex,
    required this.secontPointIndex,
    required this.distanceToFirstPoint,
    required this.distanceToSecondPoint,
  });

  Offset getFirstPointOffset(Offset firstPoint, Offset secondPoint) {
    final firstPointDirection = MapHelper.direction(
      firstPoint,
      secondPoint,
    );

    final firstPointOffset = MapHelper.offsetFromDirection(
      firstPointDirection,
      distanceToFirstPoint,
    );

    return firstPoint + firstPointOffset;
  }

  Offset getSecondPointOffset(Offset firstPoint, Offset secondPoint) {
    final secondPointDirection = MapHelper.direction(
      secondPoint,
      firstPoint,
    );

    final secondPointOffset = MapHelper.offsetFromDirection(
      secondPointDirection,
      distanceToSecondPoint,
    );

    return secondPoint + secondPointOffset;
  }
}
