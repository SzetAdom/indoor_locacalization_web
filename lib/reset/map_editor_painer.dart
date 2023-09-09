import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_point_model.dart';

class MapEditorPainter extends CustomPainter {
  final List<MapPointModel> points;

  String? selectedPointId;

  Offset mapOffset;
  Size mapSize;

  MapEditorPainter({
    required this.points,
    required this.mapOffset,
    required this.mapSize,
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

  void drawBaseBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  void drawMapBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawRect(Rect.fromLTWH(0, 0, mapSize.width, mapSize.height), paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawBaseBackground(canvas, size);

    var horizontalOffset = (size.width / 2) - (mapSize.width / 2);
    var verticalOffset = (size.height / 2) - (mapSize.height / 2);
    canvas.translate(
      horizontalOffset,
      verticalOffset,
    );
    canvas.translate(mapOffset.dx, mapOffset.dy);
    drawMapBackground(canvas, size);
    canvas.translate(mapSize.width / 2, mapSize.height / 2);
    for (final point in points) {
      _drawPoint(canvas, point.toOffset(), point.id == selectedPointId);
    }
  }
}
