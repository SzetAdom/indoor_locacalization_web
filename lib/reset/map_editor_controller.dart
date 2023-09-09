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

    dev.log("${offset.dx} ${offset.dy}");

    map.points.sort((a, b) {
      final distanceA = (a.toOffset() - offset).distanceSquared;
      final distanceB = (b.toOffset() - offset).distanceSquared;
      return distanceA.compareTo(distanceB);
    });

    final nearestPoint = map.points.first;
    var distance = (nearestPoint.toOffset() - offset).distance;
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

  void onPanUpdate(Offset offset) {
    if (selectedPointId != null) {
      var selectedPoint =
          map.points.firstWhere((element) => element.id == selectedPointId);
      selectedPoint.x = offset.dx;
      selectedPoint.y = offset.dy;
      notifyListeners();
    }
  }

  void onPanEnd() {
    selectedPointId = null;
    notifyListeners();
  }

  String? selectedPointId;
}
