import 'dart:ui';

import 'package:flutter/material.dart';

abstract class MapObjectInterface {
  void addPoint(Offset point);
  void removePoint(Offset point);
  void movePointBy(int index, Offset offset);
  void movePointTo(int index, Offset offset);
  void moveObjectBy(Offset offset);
  void draw(Canvas canvas, Size size, {bool selected = false});
  int? isPointUnderMouse(Offset point);
  bool isObjectUnderMouse(Offset point);
}

class MapObjectModel implements MapObjectInterface {
  static const double pointRadius = 10;

  String id;
  String? name;
  Color? color;
  String? icon;
  String? description;
  List<Offset> points;

  MapObjectModel({
    required this.id,
    this.name,
    this.color,
    this.icon,
    this.description,
    required this.points,
  });

  MapObjectModel copyWith({
    String? id,
    String? name,
    Color? color,
    String? icon,
    String? description,
    List<Offset>? points,
  }) {
    return MapObjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      points: points ?? this.points,
    );
  }

  @override
  void addPoint(Offset point) {
    points.add(point);
  }

  @override
  void draw(Canvas canvas, Size size, {bool selected = false}) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = pointRadius
      ..strokeCap = StrokeCap.round;

    //draw only the points
    canvas.drawPoints(PointMode.points, points, paint);
  }

  @override
  void movePointBy(int index, Offset offset) {
    points[index] += offset;
  }

  @override
  void moveObjectBy(Offset offset) {
    for (var i = 0; i < points.length; i++) {
      points[i] += offset;
    }
  }

  @override
  void movePointTo(int index, Offset offset) {
    points[index] = offset;
  }

  @override
  void removePoint(Offset point) {
    points.remove(point);
  }

  @override
  int? isPointUnderMouse(Offset mouse) {
    for (var i = 0; i < points.length; i++) {
      var distance = (points[i] - mouse).distance;
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
}
