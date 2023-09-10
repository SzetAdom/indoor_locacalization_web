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

    if (!mapSelected) {
      map.points.sort((a, b) {
        final distanceA = (a.toOffset() - normalizedOffset).distance;
        final distanceB = (b.toOffset() - normalizedOffset).distance;
        return distanceA.compareTo(distanceB);
      });

      final nearestPoint = map.points.first;
      var distance = (nearestPoint.toOffset() - normalizedOffset).distance;
      if (distance < pointSize) {
        selectPoint(nearestPoint.id);
      } else {
        selectPoint(null);
      }
    } else {
      var mapEditorPointList = mapEditorPoints.values.toList();

      mapEditorPointList.sort((a, b) {
        final distanceA = (a - normalizedOffset).distance;
        final distanceB = (b - normalizedOffset).distance;
        return distanceA.compareTo(distanceB);
      });

      final nearestPoint = mapEditorPointList.first;
      var distance = (nearestPoint - normalizedOffset).distance;
      if (distance < mapEditPointSize) {
        selectedMapEditorPoint = mapEditorPoints.keys
            .firstWhere((element) => mapEditorPoints[element] == nearestPoint);
      } else {
        selectedMapEditorPoint = null;
      }
    }
    notifyListeners();
  }

  void onPanStart(Offset offset) {
    onTap(offset);
  }

  void onPanUpdate(DragUpdateDetails offset) {
    if (selectedPointId != null) {
      var selectedPoint =
          map.points.firstWhere((element) => element.id == selectedPointId);

      var normalizedOffset = normalize(offset.localPosition);

      //snap to grid
      if (snapToGrid) {
        if (normalizedOffset.dx % gridStep < 15) {
          normalizedOffset = Offset(
              (normalizedOffset.dx / gridStep).round() * gridStep,
              normalizedOffset.dy);
        }

        if (normalizedOffset.dy % gridStep < 15) {
          normalizedOffset = Offset(normalizedOffset.dx,
              (normalizedOffset.dy / gridStep).round() * gridStep);
        }
      }

      selectedPoint.x = normalizedOffset.dx;
      selectedPoint.y = normalizedOffset.dy;

      //if point is outside of map increase map size

      if (selectedPoint.x > 0 && selectedPoint.x > map.widthRight) {
        map.addExtraWidthRigth(selectedPoint.x.abs() - map.widthRight);
      }
      if (selectedPoint.x < 0 && selectedPoint.x.abs() > map.widthLeft) {
        map.addExtraWidthLeft(selectedPoint.x.abs() - map.widthLeft);
      }

      if (selectedPoint.y > 0 && selectedPoint.y > map.heightBottom) {
        map.addExtraHeightBottom(selectedPoint.y.abs() - map.heightBottom);
      }

      if (selectedPoint.y < 0 && selectedPoint.y.abs() > map.heightTop) {
        map.addExtraHeightTop(selectedPoint.y.abs() - map.heightTop);
      }

      notifyListeners();
    } else if (mapSelected && selectedMapEditorPoint != null) {
      var delta = offset.delta;
      if (snapToGrid) {
        var normalizedOffset = normalize(offset.localPosition);

        if (normalizedOffset.dx % gridStep < 15) {
          delta = Offset((delta.dx / gridStep).round() * gridStep, delta.dy);
        }

        if (normalizedOffset.dy % gridStep < 15) {
          delta = Offset(delta.dx, (delta.dy / gridStep).round() * gridStep);
        }
      }

      delta = delta / zoomLevel;
      switch (selectedMapEditorPoint) {
        case MapEditorPoint.topLeft:
          map.removeExtraWidthLeft(delta.dx);
          map.removeExtraHeightTop(delta.dy);
          break;
        case MapEditorPoint.topRight:
          map.addExtraWidthRigth(delta.dx);
          map.removeExtraHeightTop(delta.dy);

          break;
        case MapEditorPoint.bottomLeft:
          map.removeExtraWidthLeft(delta.dx);
          map.addExtraHeightBottom(delta.dy);
          break;
        case MapEditorPoint.bottomRight:
          map.addExtraWidthRigth(delta.dx);
          map.addExtraHeightBottom(delta.dy);

          break;
        case MapEditorPoint.left:
          map.removeExtraWidthLeft(delta.dx);

          break;
        case MapEditorPoint.right:
          map.addExtraWidthRigth(delta.dx);
          break;
        case MapEditorPoint.top:
          map.removeExtraHeightTop(delta.dy);
          break;
        case MapEditorPoint.bottom:
          map.addExtraHeightBottom(delta.dy);
          break;
        default:
      }
    } else {
      canvasOffset += offset.delta * (1 / zoomLevel);
    }
    notifyListeners();
  }

  void onPanEnd() {
    if (selectedPointId != null) {
      selectedPointId = null;
      notifyListeners();
    }
    if (selectedMapEditorPoint != null) {
      selectedMapEditorPoint = null;
      notifyListeners();
    }
  }

  Offset normalize(Offset offset) {
    return translateToMapOffset(translateFromCanvas(offset));
  }

  Offset translateFromCanvas(Offset offset) {
    var horizontalOffset = (canvasSize.width / 2) * zoomLevel;
    var verticalOffset = (canvasSize.height / 2) * zoomLevel;

    return offset.translate(-1 * horizontalOffset, -1 * verticalOffset) /
        zoomLevel;
  }

  Offset translateToMapOffset(Offset offset) {
    return offset.translate(-canvasOffset.dx, -canvasOffset.dy);
  }

  Offset canvasOffset = Offset.zero;

  String? selectedPointId;

  bool mapSelected = false;

  void selectMap(bool selected) {
    selectedPointId = null;
    mapSelected = selected;
    notifyListeners();
  }

  bool snapToGrid = false;

  void setSnapToGrid(bool value) {
    snapToGrid = value;
    notifyListeners();
  }

  void selectPoint(String? id) {
    selectedPointId = id;
    mapSelected = false;
    notifyListeners();
  }

  Map<MapEditorPoint, Offset> get mapEditorPoints {
    return {
      MapEditorPoint.topLeft: Offset(map.widthLeft * -1, map.heightTop * -1),
      MapEditorPoint.topRight: Offset(map.widthRight, map.heightTop * -1),
      MapEditorPoint.bottomLeft: Offset(map.widthLeft * -1, map.heightBottom),
      MapEditorPoint.bottomRight: Offset(map.widthRight, map.heightBottom),
      MapEditorPoint.left: Offset(map.widthLeft * -1, 0),
      MapEditorPoint.right: Offset(map.widthRight, 0),
      MapEditorPoint.top: Offset(0, map.heightTop * -1),
      MapEditorPoint.bottom: Offset(0, map.heightBottom),
    };
  }

  MapEditorPoint? selectedMapEditorPoint;

  Size canvasSize = Size.zero;

  double gridStep = 100;

  double zoomLevel = 1.0;

  double zoomSensitive = 0.07;

  double pointSize = 10;

  double get mapEditPointSize => 15 / zoomLevel;

  void zoomIn(Offset mousePosition) {
    var normalizedOffsetBefore = normalize(mousePosition);
    zoomLevel += zoomSensitive;
    var normalizedOffsetAfter = normalize(mousePosition);

    var diff = normalizedOffsetBefore - normalizedOffsetAfter;

    canvasOffset += diff * -1;
    notifyListeners();
  }

  void zoomOut(Offset mousePosition) {
    if (zoomLevel <= 0.1) return;
    var normalizedOffsetBefore = normalize(mousePosition);
    zoomLevel -= zoomSensitive;
    var normalizedOffsetAfter = normalize(mousePosition);

    var diff = normalizedOffsetBefore - normalizedOffsetAfter;

    canvasOffset += diff * -1;
    notifyListeners();
  }
}

enum MapEditorPoint {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  left,
  right,
  top,
  bottom,
}
