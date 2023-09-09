import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_editor_painer.dart';

class MapEditorBackgroundPainter extends CustomPainter {
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void drawBaseBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    MapEditorPainter p = MapEditorPainter(
      points: [],
      mapOffset: const Offset(0, 0),
      mapSize: const Size(500, 500),
    );

    p.paint(canvas, size);
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawBaseBackground(canvas, size);
  }
}
