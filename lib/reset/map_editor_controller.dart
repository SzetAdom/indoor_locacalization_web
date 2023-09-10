import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_model.dart';
import 'package:indoor_localization_web/reset/map_point_model.dart';

class MapEditorController extends ChangeNotifier {
  void save() {}

  void undo() {}

  void redo() {}

  late MapModel map;

  Future<bool> loadMap(String mapId) async {
    map = MapModel(
      id: '0',
      name: 'test',
      points: [
        MapPointModel(id: '0', description: 'gugu', x: 0, y: 0),
        MapPointModel(id: '1', description: 'gugu', x: 100, y: 100),
        MapPointModel(id: '2', description: 'gugu', x: 200, y: 200),
        MapPointModel(id: '3', description: 'gugu', x: 300, y: 300),
        MapPointModel(id: '4', description: 'gugu', x: 400, y: 400),
      ],
    );
    return true;
  }

  void onTap(Offset offset) {
    //select nearest point

    var normalizedOffset = normalize(offset);

    dev.log("${normalizedOffset.dx} ${normalizedOffset.dy}");

    map.points.sort((a, b) {
      final distanceA = (a.toOffset() - normalizedOffset).distance;
      final distanceB = (b.toOffset() - normalizedOffset).distance;
      return distanceA.compareTo(distanceB);
    });

    final nearestPoint = map.points.first;
    var distance = (nearestPoint.toOffset() - normalizedOffset).distance;
    if (distance < 10) {
      selectedPointId = nearestPoint.id;
    } else {
      selectedPointId = null;
    }
    notifyListeners();
  }

  void onPanStart(Offset offset) {
    onTap(offset);
  }

  void onPanUpdate(DragUpdateDetails offset) {
    var normalizedOffset = normalize(offset.localPosition);

    if (selectedPointId != null) {
      var selectedPoint =
          map.points.firstWhere((element) => element.id == selectedPointId);
      selectedPoint.x = normalizedOffset.dx;
      selectedPoint.y = normalizedOffset.dy;
      notifyListeners();
    } else {
      canvasOffset += offset.delta;
      notifyListeners();
    }
  }

  void onPanEnd() {
    if (selectedPointId != null) {
      //if point is outside of map increase map size
      // var selectedPoint =
      //     map.points.firstWhere((element) => element.id == selectedPointId);

      // if (selectedPoint.x > map.widthRight) {
      //   map.extraWidthRigth += (selectedPoint.x - map.widthRight) + 10;
      // } else if (selectedPoint.x < map.widthLeft) {
      //   map.extraWidthLeft += (map.widthLeft - selectedPoint.x) + 10;
      // }

      selectedPointId = null;
      notifyListeners();
    }
  }

  Offset normalize(Offset offset) {
    return translateToMapOffset(translateFromCanvas(offset));
  }

  Offset translateFromCanvas(Offset offset) {
    var horizontalOffset = (canvasSize.width / 2);
    var verticalOffset = (canvasSize.height / 2);

    return offset.translate(-1 * horizontalOffset, -1 * verticalOffset);
  }

  Offset translateToMapOffset(Offset offset) {
    return offset.translate(-canvasOffset.dx, -canvasOffset.dy);
  }

  Offset canvasOffset = Offset.zero;

  String? selectedPointId;

  Size canvasSize = Size.zero;
}
