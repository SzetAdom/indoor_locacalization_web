import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_helper.dart';
import 'package:indoor_localization_web/reset/map_object_model.dart';

class WallObject extends MapObjectModel {
  WallObject({
    required String id,
    String? name,
    Color? color,
    required double x,
    required double y,
    required String description,
    String? icon,
    List<Offset>? points,
  }) : super(
          id: id,
          name: name,
          color: color,
          icon: icon,
          description: description,
          points: points ?? [],
        );

  @override
  void draw(Canvas canvas, Size size, {bool selected = false}) {
    final path = Path();

    path.moveTo(points.first.dx, points.first.dy);

    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    path.close();

    final fillPaint = Paint()
      ..color = color?.withOpacity(0.5) ?? Colors.red.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    final drawPaint = Paint()
      ..color = color ?? Colors.red
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, drawPaint);

    //draw only the points
    if (selected) {
      super.draw(canvas, size);
    }
  }

  @override
  bool isObjectUnderMouse(Offset point) {
    if (MapHelper.edgeContainsWithTolerance(points, point, tolerance: 1)) {
      return true;
    }

    //check if the point is inside the polygon
    //https://stackoverflow.com/questions/217578/how-can-i-determine-whether-a-2d-point-is-within-a-polygon
    bool pointContains = MapHelper.polyContains(
        points.length,
        points.map((e) => e.dx).toList(),
        points.map((e) => e.dy).toList(),
        point);

    return pointContains;
  }
}
