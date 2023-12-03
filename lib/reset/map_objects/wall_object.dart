import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_helper.dart';
import 'package:indoor_localization_web/reset/map_objects/map_object_model.dart';
import 'package:indoor_localization_web/reset/map_objects/door_model.dart';
import 'package:indoor_localization_web/reset/map_objects/wall_object_point_model.dart';
import 'package:json_annotation/json_annotation.dart';

class WallObject extends MapObjectModel {
  WallObject({
    required String id,
    String? name,
    required String description,
    String? icon,
    List<WallObjectPointModel>? pointsRaw,
    required this.doors,
  }) : super(
          id: id,
          name: name,
          icon: icon,
          description: description,
          pointsRaw: pointsRaw ?? [],
        );

  List<DoorModel> doors = [];

  factory WallObject.fromJson(Map<String, dynamic> json) {
    return WallObject(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      description: json['description'],
      pointsRaw: (json['pointsRaw'] as List<dynamic>)
          .map((e) => WallObjectPointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      doors: (json['doors'] as List<dynamic>)
          .map((e) => DoorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'description': description,
        'pointsRaw': pointsRaw.map((e) => e.toJson()).toList(),
        'doors': doors.map((e) => e.toJson()).toList(),
      };

  @override
  void draw(Canvas canvas, Size size, {bool selected = false}) {
    fillBackground(canvas, size);
    drawWallsWithoutDoors(canvas, size);
    // drawWallsWithDoors(canvas, size);

    if (selected) {
      drawEditPoints(canvas, size);

      drawDoorEditPoints(canvas, size);
    }

    // //draw center
    // final center = getCenter();

    // final centerPaint = Paint()
    //   ..color = Colors.red
    //   ..strokeWidth = 10
    //   ..strokeCap = StrokeCap.round;

    // canvas.drawPoints(PointMode.points, [center], centerPaint);
  }

  void fillBackground(Canvas canvas, Size size) {
    final path = Path();

    path.moveTo(points.first.point.dx, points.first.point.dy);

    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].point.dx, points[i].point.dy);
    }

    path.close();

    final fillPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    canvas.drawPath(fullPath, fillPaint);
  }

  void drawEditPoints(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawPoints(
        PointMode.points, points.map((e) => e.point).toList(), paint);

    //write the point index

    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 20,
    );

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (var i = 0; i < points.length; i++) {
      textPainter.text = TextSpan(
        text: '$i',
        style: textStyle,
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(
            points[i].point.dx + 10, points[i].point.dy - textPainter.height),
      );
    }
  }

  void drawDoorEditPoints(Canvas canvas, Size size) {
    var doorPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.square;

    for (var door in doors) {
      final firstPoint = points[door.firstPointIndex];
      final secondPoint = points[door.secontPointIndex];

      final firstPointDoor =
          door.getFirstPointOffset(firstPoint.point, secondPoint.point);
      final secondPointDoor =
          door.getSecondPointOffset(firstPoint.point, secondPoint.point);

      canvas.drawPoints(PointMode.points, [firstPointDoor], doorPaint);

      canvas.drawPoints(PointMode.points, [secondPointDoor], doorPaint);
    }
  }

  Path get fullPath {
    final path = Path();

    path.moveTo(points.first.point.dx, points.first.point.dy);

    for (var i = 0; i < points.length; i++) {
      path.lineTo(points[i].point.dx, points[i].point.dy);
    }

    path.close();

    return path;
  }

  void drawWallsWithoutDoors(Canvas canvas, Size size) {
    final path = Path();

    path.moveTo(points.first.point.dx, points.first.point.dy);

    for (var i = 0; i < points.length; i++) {
      //next point
      final nextPoint = points[(i + 1) % points.length];
      if (!doors.any((element) => element.firstPointIndex == i)) {
        //line to next point
        path.lineTo(nextPoint.point.dx, nextPoint.point.dy);
      } else {
        //iterate through doors on this wall
        for (var door
            in doors.where((element) => element.firstPointIndex == i)) {
          final firstPoint = points[door.firstPointIndex];
          final secondPoint = points[door.secontPointIndex];

          final firstPointDoor =
              door.getFirstPointOffset(firstPoint.point, secondPoint.point);

          path.lineTo(firstPointDoor.dx, firstPointDoor.dy);

          final secondPointDoor =
              door.getSecondPointOffset(firstPoint.point, secondPoint.point);

          path.moveTo(secondPointDoor.dx, secondPointDoor.dy);

          path.lineTo(nextPoint.point.dx, nextPoint.point.dy);
        }
      }
    }

    final drawPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, drawPaint);
  }

  Path get doorPaths {
    final path = Path();

    for (var door in doors) {
      final doorPath = Path();

      final firstPoint = points[door.firstPointIndex];
      final secondPoint = points[door.secontPointIndex];

      final firstPointDoor =
          door.getFirstPointOffset(firstPoint.point, secondPoint.point);
      final secondPointDoor =
          door.getSecondPointOffset(firstPoint.point, secondPoint.point);

      doorPath.moveTo(firstPointDoor.dx, firstPointDoor.dy);
      doorPath.lineTo(secondPointDoor.dx, secondPointDoor.dy);

      doorPath.close();

      path.addPath(doorPath, Offset.zero);
    }

    return path;
  }

  @override
  bool isObjectUnderMouse(Offset point) {
    if (MapHelper.edgeContainsWithTolerance(
        points.map((e) => e.point).toList(), point,
        tolerance: 1)) {
      return true;
    }

    //check if the point is inside the polygon
    //https://stackoverflow.com/questions/217578/how-can-i-determine-whether-a-2d-point-is-within-a-polygon
    bool pointContains = MapHelper.polyContains(
        points.length,
        points.map((e) => e.point.dx).toList(),
        points.map((e) => e.point.dy).toList(),
        point);

    return pointContains;
  }
}
