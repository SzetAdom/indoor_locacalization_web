import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_object_model.dart';
import 'package:indoor_localization_web/reset/map_point_model.dart';

class WallObject extends MapObjectModel {
  WallObject({
    required String id,
    String? name,
    Color? color,
    required double x,
    required double y,
    required String description,
    String? icon,
    List<MapPointModel>? points,
  }) : super(
          id: id,
          name: name,
          color: color,
          icon: icon,
          description: description,
          points: points ?? [],
        );

  factory WallObject.fromJson(Map<String, dynamic> json) {
    return WallObject(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      x: json['x'],
      y: json['y'],
      description: json['description'],
      icon: json['icon'],
      points: (json['points'] as List<dynamic>)
          .map((e) => MapPointModel.fromJson(e))
          .toList(),
    );
  }

  @override
  void draw(Canvas canvas, Size size) {
    final path = Path();

    path.moveTo(points.first.x, points.first.y);

    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].x, points[i].y);
    }

    path.close();

    final fillPaint = Paint()
      ..color = color ?? Colors.red.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    final drawPaint = Paint()
      ..color = color ?? Colors.red
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, drawPaint);
    super.draw(canvas, size);
  }
}
