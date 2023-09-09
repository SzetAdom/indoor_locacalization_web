import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_point_model.dart';

class MapEditorPainter extends CustomPainter {
  final List<MapPointModel> points;

  String? selectedPointId;

  MapEditorPainter({
    required this.points,
    this.selectedPointId,
  });

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawPoint(Canvas canvas, Offset point, bool selected) {
    final paint = Paint()
      ..color = selected ? Colors.red : Colors.blue
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawPoints(PointMode.points, [point], paint);
  }

  void drawMapBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // drawMapBackground(canvas, size);
    // canvas.translate(size.width / 2, size.height / 2);
    for (final point in points) {
      _drawPoint(canvas, point.toOffset(), point.id == selectedPointId);
    }
  }
}
