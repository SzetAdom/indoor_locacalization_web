import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_objects/wall_object.dart';
import 'package:indoor_localization_web/reset/model/map_object_point_model.dart';
import 'package:json_annotation/json_annotation.dart';

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

enum MapObjectType { wall }

@JsonSerializable()
class MapObjectModel implements MapObjectInterface {
  static const double pointRadius = 10;

  String id;
  String? name;
  String? icon;
  String? description;
  MapObjectType type;
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
    this.type = MapObjectType.wall,
    this.name,
    this.icon,
    this.description,
    required this.pointsRaw,
  });

  factory MapObjectModel.fromJson(Map<String, dynamic> json) {
    var type = json['type'];
    switch (type) {
      case 'wall':
        return WallObject.fromJson(json);
      default:
        return MapObjectModel(
          id: json['id'],
          name: json['name'],
          icon: json['icon'],
          description: json['description'],
          pointsRaw: (json['pointsRaw'] as List<dynamic>)
              .map((e) =>
                  MapObjectPointModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );                                                                                                                                                                                                                                                                                                                                                                                                                             
    }
  }

  Map<String, dynamic> toJson() {
    var res = <String, dynamic>{
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'type': type,
      'pointsRaw': pointsRaw,
    };
    return res;
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
    var path = Path();
    path.moveTo(points.first.point.dx, points.first.point.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].point.dx, points[i].point.dy);
    }
    path.close();
    return path.contains(point);
    return false;
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
