import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/model/map/map_data_model.dart';
import 'package:indoor_localization_web/reset/model/map_object/map_object_data_model.dart';
import 'package:indoor_localization_web/reset/model/map_object/map_object_model.dart';
import 'package:indoor_localization_web/reset/widget/map_object/edit/map_object_editor_widget.dart';

class MapObjectEditorController extends ChangeNotifier {
  MapObjectEditorController();

  final MapDataModel mapDataModel = MapDataModel(
    id: '',
    name: '',
    description: '',
    image: '',
    objects: [
      MapObjectModel(
        id: '1',
        color: Colors.grey,
        name: 'Object 1',
        description: 'Object 1 description',
        icon: const Icon(Icons.ac_unit),
        data: MapObjectDataModel(
          x: 100,
          y: 100,
          width: 100,
          height: 100,
          angle: 30,
        ),
      ),
      MapObjectModel(
        id: '2',
        color: Colors.grey,
        name: 'Object 1',
        description: 'Object 1 description',
        icon: const Icon(Icons.ac_unit),
        data: MapObjectDataModel(
          x: 200,
          y: 200,
          width: 100,
          height: 100,
          angle: 30,
        ),
      ),
    ],
  );

  int selectedIndex = -1;

  double scale = 1;

  changeScale(double newScale) {
    scale = newScale;
    notifyListeners();
  }

  Future<bool> init() async {
    try {} catch (e) {
      log(e.toString());
      return false;
    }

    return true;
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
