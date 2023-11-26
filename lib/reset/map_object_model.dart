import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/model/map_object_point_model.dart';

abstract class MapObjectInterface {
  void addPoint(MapObjectPointModel point);
  void removePoint(MapObjectPointModel point);
  void movePointBy(int index, Offset offset);
  void movePointTo(int index, Offset offset);
  void moveObjectBy(Offset offset);
  void draw(Canvas canvas, Size size, {bool selected = false});
  int? isPointUnderMouse(Offset point);
  bool isObjectUnderMouse(Offset point);
  List<MapObjectPointModel> rotateObject();
}

class MapObjectModel implements MapObjectInterface {
  static const double pointRadius = 10;

  String id;
  String? name;
  Color? color;
  String? icon;
  String? description;
  // List<MapObjectPointModel> points;
  List<MapObjectPointModel> pointsRaw = [];
  List<MapObjectPointModel> get points {
    var res = rotateObject();
    pointsRaw = res;
    angle = 0;
    return pointsRaw;
  }

  double angle = 0;

  MapObjectModel({
    required this.id,
    this.name,
    this.color,
    this.icon,
    this.description,
    required this.pointsRaw,
  });

  MapObjectModel copyWith({
    String? id,
    String? name,
    Color? color,
    String? icon,
    String? description,
    List<MapObjectPointModel>? pointsRaw,
    double? rotation,
  }) {
    return MapObjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      pointsRaw: pointsRaw ?? this.pointsRaw,
    );
  }

  @override
  void addPoint(MapObjectPointModel point) {
    pointsRaw.add(point);
  }

  @override
  void draw(Canvas canvas, Size size, {bool selected = false}) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = pointRadius
      ..strokeCap = StrokeCap.round;

    //draw only the points
    canvas.drawPoints(
        PointMode.points, points.map((e) => e.point).toList(), paint);
  }

  @override
  void movePointBy(int index, Offset offset) {
    //calculate in the angle
    // var rotatedOffset = rotateDeltaOffset(offset);
    pointsRaw[index].point += offset;
  }

  @override
  void moveObjectBy(Offset offset) {
    for (var i = 0; i < points.length; i++) {
      pointsRaw[i].point += offset;
    }
  }

  @override
  void movePointTo(int index, Offset offset) {
    pointsRaw[index].point = offset;
  }

  @override
  void removePoint(MapObjectPointModel point) {
    pointsRaw.remove(point);
  }

  @override
  int? isPointUnderMouse(Offset mouse) {
    for (var i = 0; i < points.length; i++) {
      var distance = (points[i].point - mouse).distance;
      if (distance < pointRadius) {
        return i;
      }
    }
    return null;
  }

  @override
  bool isObjectUnderMouse(Offset point) {
    throw UnimplementedError();
  }

  Offset getCenter() {
    var center = Offset.zero;
    for (var i = 0; i < pointsRaw.length; i++) {
      center += pointsRaw[i].point;
    }
    center = center / (pointsRaw.length as double);
    return center;
  }

  double get angelInRadian => angle * pi / 180;

  @override
  List<MapObjectPointModel> rotateObject() {
    List<MapObjectPointModel> res = [];

    //rotate around center
    var center = getCenter();

    for (var i = 0; i < pointsRaw.length; i++) {
      var offset = pointsRaw[i].point;
      var rotatedPoint = Offset(
        (offset.dx - center.dx) * cos(angelInRadian) -
            (offset.dy - center.dy) * sin(angelInRadian) +
            center.dx,
        (offset.dx - center.dx) * sin(angelInRadian) +
            (offset.dy - center.dy) * cos(angelInRadian) +
            center.dy,
      );

      res.add(MapObjectPointModel(point: rotatedPoint));
    }

    return res;
  }
}
