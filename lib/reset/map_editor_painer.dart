import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_model.dart';

class MapEditorPainter extends CustomPainter {
  String? selectedPointId;
  Offset canvasOffset;

  MapModel map;

  MapEditorPainter({
    required this.map,
    required this.canvasOffset,
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

    canvas.drawRect(Rect.fromLTWH(0, 0, map.width, map.height), paint);

    //draw grid

    final gridPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    const gridStep = 50;

    for (var i = 0; i < map.width; i += gridStep) {
      canvas.drawLine(
          Offset(i.toDouble(), 0), Offset(i.toDouble(), map.height), gridPaint);
    }

    for (var i = 0; i < map.height; i += gridStep) {
      canvas.drawLine(
          Offset(0, i.toDouble()), Offset(map.width, i.toDouble()), gridPaint);
    }

    //draw axis

    final axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
        Offset(map.width / 2, 0), Offset(map.width / 2, map.height), axisPaint);

    canvas.drawLine(Offset(0, map.height / 2),
        Offset(map.width, map.height / 2), axisPaint);

    //draw axis labels

    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 20,
    );

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.text = const TextSpan(
      text: 'x',
      style: textStyle,
    );

    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(map.width - textPainter.width, map.height / 2),
    );

    textPainter.text = const TextSpan(
      text: 'y',
      style: textStyle,
    );

    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(map.width / 2, 0),
    );

    //draw map size

    textPainter.text = TextSpan(
      text: 'width: ${map.width}',
      style: textStyle,
    );

    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(0, map.height - textPainter.height),
    );

    textPainter.text = TextSpan(
      text: 'height: ${map.height}',
      style: textStyle,
    );

    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(0, map.height - textPainter.height * 2),
    );

    //draw map offset

    textPainter.text = TextSpan(
      text: 'offset: ${canvasOffset.dx}, ${canvasOffset.dy}',
      style: textStyle,
    );

    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(0, map.height - textPainter.height * 3),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawBaseBackground(canvas, size);

    var horizontalOffset = (size.width / 2) - (map.baseWidth / 2);
    var verticalOffset = (size.height / 2) - (map.baseHeight / 2);
    canvas.translate(
      horizontalOffset,
      verticalOffset,
    );
    canvas.translate(canvasOffset.dx, canvasOffset.dy);
    drawMapBackground(canvas, size);
    canvas.translate(map.width / 2, map.height / 2);
    for (final point in map.points) {
      _drawPoint(canvas, point.toOffset(), point.id == selectedPointId);
    }
  }
}
