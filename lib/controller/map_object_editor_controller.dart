import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:indoor_localization_web/model/map/map_data_model.dart';
import 'package:indoor_localization_web/model/map_object/map_object_data_model.dart';
import 'package:indoor_localization_web/model/map_object/map_object_model.dart';
import 'package:indoor_localization_web/widget/map_object/edit/map_object_editor_widget.dart';

class MapObjectEditorController extends ChangeNotifier {
  MapObjectEditorController();

  final MapDataModel mapDataModel = MapDataModel(
    id: '',
    userId: '',
    name: '',
    description: '',
    width: 500,
    height: 500,
    image: '',
    objects: [],
  );

  int selectedIndex = -1;

  double scale = 1;

  changeScale(double newScale) {
    scale = newScale;
    notifyListeners();
  }

  String? _mapId;

  Future<bool> init(String mapId) async {
    _mapId = mapId;
    try {
      var firestore = FirebaseFirestore.instance;
      final map = await firestore.collection('maps').doc(mapId).get();
      if (map.exists) {
        mapDataModel.id = map.id;
        mapDataModel.userId = map['user_id'];
        mapDataModel.name = map['name'];
        mapDataModel.description = map['description'];
        mapDataModel.image = '';
        mapDataModel.objects = [];

        if (map.data()!.containsKey('objects')) {
          for (final object in map['objects']) {
            mapDataModel.objects.add(MapObjectModel(
              color: Colors.grey,
              name: object['name'],
              description: object['description'],
              icon: const Icon(Icons.ac_unit),
              data: MapObjectDataModel(
                x: object['x'],
                y: object['y'],
                width: object['width'],
                height: object['height'],
                angle: object['angle'],
              ),
            ));
          }
        }

        return true;
      }
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future<void> save() async {
    var maps = FirebaseFirestore.instance.collection('maps');
    var newData = mapDataModel.toJson();
    maps.doc(_mapId).set(newData);
  }

  void addObject() {
    mapDataModel.objects.add(MapObjectModel(
      color: Colors.grey,
      name: 'New Object',
      description: 'New Object',
      icon: const Icon(Icons.ac_unit),
      data: MapObjectDataModel(
        x: mapDataModel.width / 2,
        y: mapDataModel.height / 2,
        width: 100,
        height: 100,
        angle: 0,
      ),
    ));
    notifyListeners();
  }

  MapObjectEditorWidget getEditWidget(int index) {
    return MapObjectEditorWidget(
      mapDataModel.objects[index],
      selectedCallback: (bool selected) {
        selectObject(index, selected);
      },
      onChange: (newModel) {
        updateSelected(newModel);
        updatePanel?.call();
      },
      selected: selectedIndex == index,
    );
  }

  bool get mapSelected => selectedIndex == -1;

  void selectObject(int index, bool selected) {
    selectedIndex = selected ? index : -1;

    notifyListeners();
  }

  MapObjectModel? get selectedMapObject =>
      selectedIndex == -1 ? null : mapDataModel.objects[selectedIndex];

  notify() {
    notifyListeners();
  }

  void updateSelected(MapObjectModel mapObjectModel) {
    if (selectedIndex != -1) {
      mapDataModel.objects[selectedIndex] = mapObjectModel;
      notifyListeners();
    }
  }

  void updateSelectedData(MapObjectDataModel newModel) {
    if (selectedIndex != -1) {
      mapDataModel.objects[selectedIndex].data = newModel;
      notifyListeners();
    }
  }

  void updateSelectedModel(MapObjectModel newModel) {
    if (selectedIndex != -1) {
      mapDataModel.objects[selectedIndex] = newModel;
      notifyListeners();
    }
  }

  Function? updatePanel;
}
