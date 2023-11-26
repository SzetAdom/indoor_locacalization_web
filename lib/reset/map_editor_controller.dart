import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_model.dart';
import 'package:indoor_localization_web/reset/map_object_model.dart';
import 'package:indoor_localization_web/reset/map_objects/wall_object.dart';
import 'package:indoor_localization_web/reset/model/door_model.dart';
import 'package:indoor_localization_web/reset/model/map_object_point_model.dart';
import 'package:indoor_localization_web/reset/model/wall_object_point_model.dart';

enum EditMode {
  select,
  move,
  resize,
}

class MapEditorController extends ChangeNotifier {
  EditMode editMode = EditMode.select;

  void setEditMode(EditMode mode) {
    editMode = mode;
    notifyListeners();
  }

  void save() {}

  void undo() {}

  void redo() {}

  late MapModel map;

  Future<bool> loadMap(String mapId) async {
    map = MapModel(
      id: '0',
      name: 'test',
      objects: [
        WallObject(
            id: '0',
            name: 'Szoba 1',
            x: 0,
            y: 0,
            description: '',
            pointsRaw: [
              WallObjectPointModel(point: const Offset(50, 50), isDoor: false),
              WallObjectPointModel(point: const Offset(50, 150), isDoor: false),
              WallObjectPointModel(
                  point: const Offset(150, 150), isDoor: false),
              WallObjectPointModel(point: const Offset(150, 50), isDoor: false),
            ],
            doors: [
              DoorModel(
                firstPointIndex: 0,
                secontPointIndex: 1,
                distanceToFirstPoint: 20,
                distanceToSecondPoint: 20,
              )
            ]),
        WallObject(
            id: '1',
            name: 'Szoba 2',
            x: 0,
            y: 0,
            description: '',
            pointsRaw: [
              WallObjectPointModel(
                  point: const Offset(250, 250), isDoor: false),
              WallObjectPointModel(
                  point: const Offset(250, 350), isDoor: false),
              WallObjectPointModel(
                  point: const Offset(350, 350), isDoor: false),
              WallObjectPointModel(
                  point: const Offset(350, 250), isDoor: false),
            ],
            doors: [
              DoorModel(
                firstPointIndex: 0,
                secontPointIndex: 1,
                distanceToFirstPoint: 20,
                distanceToSecondPoint: 20,
              )
            ]),
        // WallObject(
        //     id: '1',
        //     color: Colors.green,
        //     x: 0,
        //     y: 0,
        //     description: '',
        //     points: [
        //       const Offset(0, 0),
        //       const Offset(0, 100),
        //       const Offset(100, 100),
        //       const Offset(100, 0),
        //     ]),
      ],
    );
    return true;
  }

  void updateObject(MapObjectModel object) {
    map.objects[map.objects.indexWhere((element) => element.id == object.id)] =
        object;
    notifyListeners();
  }

  void addObject(MapObjectModel object) {
    map.objects.add(object);
    notifyListeners();
  }

  void removeObject(String id) {
    map.objects.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void onTap(Offset offset, {bool deselect = true}) {
    //select nearest point

    var normalizedOffset = normalize(offset);

    if (!mapSelected) {
      //check if point is under mouse
      for (var i = map.objects.length - 1; i >= 0; i--) {
        try {
          var point = map.objects[i].isPointUnderMouse(normalizedOffset);
          if (point != null) {
            selectObject(map.objects[i].id, index: point);
            return;
          } else {
            //if mouse is inside object select object
            bool isObjectSelected =
                map.objects[i].isObjectUnderMouse(normalizedOffset);
            if (isObjectSelected) {
              selectObject(map.objects[i].id);
              return;
            }
          }
        } catch (e) {
          print(e);
        }
      }
      if (deselect) {
        selectObject(null);
      }
      // var points = map.objects.expand((element) => element.points).toList();

      // points.sort((a, b) {
      //   final distanceA = (a - normalizedOffset).distance;
      //   final distanceB = (b - normalizedOffset).distance;
      //   return distanceA.compareTo(distanceB);
      // });

      // final nearestPoint = points.first;
      // var distance = (nearestPoint - normalizedOffset).distance;
      // if (distance < pointSize) {
      //   selectPoint(nearestPoint);
      // } else {
      //   selectPoint(null);
      // }
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
        selectMapEditorPoint(mapEditorPoints.keys
            .firstWhere((element) => mapEditorPoints[element] == nearestPoint));
      } else {
        selectMapEditorPoint(null);
      }
    }
  }

  void onPanStart(Offset offset) {
    onTap(offset, deselect: false);
  }

  MapObjectModel? get selectedObject {
    if (selectedObjectId == null) return null;
    return map.objects.firstWhere((element) => element.id == selectedObjectId);
  }

  MapObjectPointModel? get selectedPoint {
    if (selectedObjectId == null || selectedPointIndex == null) return null;
    return selectedObject!.points[selectedPointIndex!];
  }

  void onPanUpdate(DragUpdateDetails offset) {
    if (selectedObjectId != null) {
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

      if (selectedPointIndex == null) {
        map.objects[map.objects.indexWhere(
                (element) => element.id == selectedObjectId)] //get object
            .moveObjectBy(offset.delta * 1 / zoomLevel); //move point
      } else {
        //move point by
        selectedObject!.movePointBy(selectedPointIndex!, offset.delta);

        // map.objects[map.objects.indexWhere(
        //         (element) => element.id == selectedObjectId)] //get object
        //     .movePointTo(selectedPointIndex!, normalizedOffset); //move point

        if (selectedPoint!.point.dx > 0 &&
            selectedPoint!.point.dx > map.widthRight) {
          map.addExtraWidthRigth(
              selectedPoint!.point.dx.abs() - map.widthRight);
        }
        if (selectedPoint!.point.dx < 0 &&
            selectedPoint!.point.dx.abs() > map.widthLeft) {
          map.addExtraWidthLeft(selectedPoint!.point.dx.abs() - map.widthLeft);
        }

        if (selectedPoint!.point.dy > 0 &&
            selectedPoint!.point.dy > map.heightBottom) {
          map.addExtraHeightBottom(
              selectedPoint!.point.dy.abs() - map.heightBottom);
        }

        if (selectedPoint!.point.dy < 0 &&
            selectedPoint!.point.dy.abs() > map.heightTop) {
          map.addExtraHeightTop(selectedPoint!.point.dy.abs() - map.heightTop);
        }
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
    if (selectedObjectId != null) {
      // selectedObjectId = null;
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

  String? selectedObjectId;
  int? selectedPointIndex;

  bool mapSelected = false;

  void selectMap(bool selected) {
    selectedObjectId = null;
    mapSelected = selected;
    notifyListeners();
  }

  bool snapToGrid = false;

  void setSnapToGrid(bool value) {
    snapToGrid = value;
    notifyListeners();
  }

  void selectObject(String? objectId, {int? index}) {
    selectedObjectId = objectId;
    selectedPointIndex = index;
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

  void selectMapEditorPoint(MapEditorPoint? point) {
    selectedMapEditorPoint = point;
    notifyListeners();
  }

  Size canvasSize = Size.zero;

  double gridStep = 1000;

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
