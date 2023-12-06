// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_objects/door_model.dart';
import 'package:indoor_localization_web/reset/map_objects/wall_object.dart';
import 'package:indoor_localization_web/reset/map_objects/wall_object_point_model.dart';
import 'package:indoor_localization_web/reset/model/map_beacon_model.dart';
import 'package:indoor_localization_web/reset/model/map_model.dart';
import 'package:indoor_localization_web/reset/model/map_object_point_model.dart';
import 'package:indoor_localization_web/reset/model/test_point_model.dart';

class MapEditorController extends ChangeNotifier {
  late MapModel map;

  Future<bool> loadMap() async {
    map = MapModel(id: '0', name: 'test', objects: []);

    map.testPoints = [
      TestPointModel(point: const Offset(0, 0), id: '0', name: 'Origó'),
      TestPointModel(point: const Offset(0, 100), id: '1', name: 'Ajtó előtt'),
      TestPointModel(
          point: const Offset(100, 100), id: '2', name: 'Fürdőszoba ajtó'),
      TestPointModel(
          point: const Offset(200, 100), id: '3', name: 'Fürdőszoba'),
      TestPointModel(point: const Offset(100, 200), id: '4', name: 'Tároló'),
      TestPointModel(
          point: const Offset(-100, 100), id: '5', name: 'Háló előtt'),
      TestPointModel(point: const Offset(-100, 0), id: '6', name: 'Háló ajtó'),
      TestPointModel(point: const Offset(-100, -100), id: '7', name: 'Háló'),
      TestPointModel(point: const Offset(-200, 100), id: '8', name: 'Nappali'),
      TestPointModel(
          point: const Offset(-200, 200), id: '9', name: 'Konyhapult'),
      TestPointModel(
          point: const Offset(-200, 300), id: '10', name: 'Konyha 1'),
      TestPointModel(
          point: const Offset(-100, 300), id: '11', name: 'Konyha 2'),
      TestPointModel(
          point: const Offset(-500, 50), id: '12', name: 'Íróasztal 1'),
      TestPointModel(
          point: const Offset(-350, 200), id: '13', name: 'Íróasztal 2'),
      TestPointModel(point: const Offset(-500, 150), id: '14', name: 'Nappali'),
      TestPointModel(point: const Offset(-500, 400), id: '15', name: 'Nappali'),
    ];

    map.beacons = [
      MapBeaconModel(
          point: const Offset(250, 100),
          uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FEEA'),
      MapBeaconModel(
          point: const Offset(-35, -170),
          uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FEEB'),
      MapBeaconModel(
          point: const Offset(-500, 500),
          uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FEEC'),
    ];

    for (int i = 0; i < 1; i++) {
      map.objects.addAll(
        [
          WallObject(
              id: '${i}_0.0',
              name: 'Nappali',
              description: '',
              pointsRaw: [
                WallObjectPointModel(point: const Offset(-580, -0)),
                WallObjectPointModel(point: const Offset(-580, 535)),
                WallObjectPointModel(point: const Offset(115, 250)),
                WallObjectPointModel(point: const Offset(100, 0)),
              ],
              doors: const []),
          WallObject(
              id: '${i}_1.0',
              name: 'Hálószoba',
              description: '',
              pointsRaw: [
                WallObjectPointModel(point: const Offset(0, 0)),
                WallObjectPointModel(point: const Offset(-380, 0)),
                WallObjectPointModel(point: const Offset(-380, -270)),
                WallObjectPointModel(point: const Offset(0, -270)),
              ],
              doors: [
                DoorModel(
                  firstPointIndex: 0,
                  secontPointIndex: 1,
                  distanceToFirstPoint: 86,
                  distanceToSecondPoint: 204,
                )
              ]),
          WallObject(id: '${i}_1.1', name: 'Ágy', description: '', pointsRaw: [
            WallObjectPointModel(point: const Offset(-160, -270)),
            WallObjectPointModel(point: const Offset(-160, -65)),
            WallObjectPointModel(point: const Offset(-345, -65)),
            WallObjectPointModel(point: const Offset(-345, -270)),
          ], doors: const []),
          WallObject(
              id: '${i}_1.2',
              name: 'Szekrény',
              description: '',
              pointsRaw: [
                WallObjectPointModel(point: const Offset(-0, -270)),
                WallObjectPointModel(point: const Offset(-0, -65)),
                WallObjectPointModel(point: const Offset(-50, -65)),
                WallObjectPointModel(point: const Offset(-50, -270)),
              ],
              doors: const []),
          WallObject(
              id: '${i}_2.0',
              name: 'Fürdőszoba',
              description: '',
              pointsRaw: [
                WallObjectPointModel(point: const Offset(115, 250)),
                WallObjectPointModel(point: const Offset(305, 250)),
                WallObjectPointModel(point: const Offset(305, 0)),
                WallObjectPointModel(point: const Offset(100, 0)),
              ],
              doors: const []),
          WallObject(
              id: '${i}_3.0',
              name: 'Tároló',
              description: '',
              pointsRaw: [
                WallObjectPointModel(point: const Offset(115, 250)),
                WallObjectPointModel(point: const Offset(110, 172)),
                WallObjectPointModel(point: const Offset(-55, 175)),
                WallObjectPointModel(point: const Offset(-63, 323)),
              ],
              doors: const []),
          WallObject(
              id: '${i}_4.0',
              name: 'Konyhapult',
              description: '',
              pointsRaw: [
                WallObjectPointModel(point: const Offset(-180, 225)),
                WallObjectPointModel(point: const Offset(-180, 175)),
                WallObjectPointModel(point: const Offset(-55, 175)),
                WallObjectPointModel(point: const Offset(-60, 225)),
              ],
              doors: const []),
          WallObject(
              id: '${i}_5.0',
              name: 'Íróasztal 1',
              description: '',
              pointsRaw: [
                WallObjectPointModel(point: const Offset(-580, 100)),
                WallObjectPointModel(point: const Offset(-580, 40)),
                WallObjectPointModel(point: const Offset(-455, 40)),
                WallObjectPointModel(point: const Offset(-455, 100)),
              ],
              doors: const []),
          WallObject(
              id: '${i}_5.1',
              name: 'Íróasztal 2',
              description: '',
              pointsRaw: [
                WallObjectPointModel(point: const Offset(-580, 160)),
                WallObjectPointModel(point: const Offset(-580, 100)),
                WallObjectPointModel(point: const Offset(-455, 100)),
                WallObjectPointModel(point: const Offset(-455, 160)),
              ],
              doors: const []),
          WallObject(
              id: '${i}_5.2',
              name: 'Kanapé',
              description: '',
              pointsRaw: [
                WallObjectPointModel(point: const Offset(-580, 400)),
                WallObjectPointModel(point: const Offset(-580, 200)),
                WallObjectPointModel(point: const Offset(-500, 200)),
                WallObjectPointModel(point: const Offset(-500, 400)),
              ],
              doors: const []),
        ],
      );
    }
    return true;
  }

  void export() {
    if (kDebugMode) {
      print(map.toJson());
    }

    var json = jsonEncode(map.toJson());

    var blob = Blob([json], 'application/json');

    var url = Url.createObjectUrl(blob);

    var anchor = AnchorElement()
      ..href = url
      ..download = '${map.name}.json';

    anchor.click();

    Url.revokeObjectUrl(url);
  }

  Future<String> openFile() async {
    var input = FileUploadInputElement();
    input.accept = '.json';
    input.click();

    await input.onChange.first;

    var file = input.files!.first;

    var reader = FileReader();
    reader.readAsText(file);

    await reader.onLoad.first;

    return reader.result as String;
  }

  void setMap(String json) {
    var mapModel = MapModel.fromJson(jsonDecode(json));
    map = mapModel;
    notifyListeners();
  }

  void updateObject(WallObject object) {
    map.objects[map.objects.indexWhere((element) => element.id == object.id)] =
        object;
    notifyListeners();
  }

  void addObject(WallObject object) {
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
          if (kDebugMode) {
            print(e);
          }
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

  WallObject? get selectedObject {
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
