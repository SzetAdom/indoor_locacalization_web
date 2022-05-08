import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:indoor_localization_web/controllers/map_object_controller.dart';
import 'package:indoor_localization_web/widgets/map_object.dart';

class MapObjectProvider extends ChangeNotifier {
  String name;
  MapObjectProvider(this.name);

  List<MapObject> objects = [];

  int selectedIndex = -1;

  bool mapSelected = true;

  void notify() {
    notifyListeners();
  }

  void addObjectFromJson(Map<String, dynamic> importObject) {
    int currIndex = objects.length;

    objects.add(
      MapObject(
        controller: MapObjectController.fromJson(
          importObject,
          onSelect: (selected) {
            if (selected) {
              setSelected(currIndex);
            } else {
              setMapSelected();
            }
          },
          onChangeNotify: notify,
        ),
      ),
    );
    // notifyListeners();
  }

  void addObject() {
    int currIndex = objects.length;
    objects.add(
      MapObject(
        controller: MapObjectController(
          'wall$currIndex',
          onSelect: (selected) {
            if (selected) {
              setSelected(currIndex);
            } else {
              setMapSelected();
            }
          },
          onChangeNotify: notify,
        ),
      ),
    );
    notifyListeners();
  }

  MapObjectController? getSelected() {
    if (selectedIndex == -1) {
      return null;
    }
    return objects[selectedIndex].controller;
  }

  void removeObject() {
    if (selectedIndex == -1) {
      return;
    }
    log(selectedIndex.toString());
    objects.removeAt(selectedIndex);

    for (var i = 0; i < objects.length; i++) {
      objects[i].controller.onSelect = (selected) {
        if (selected) {
          setSelected(i);
        } else {
          setMapSelected();
        }
      };
    }

    selectedIndex = -1;
    mapSelected = true;
  }

  void setSelected(int index, {bool notifyWidget = false}) {
    mapSelected = false;
    saveObject();
    selectedIndex = index;
    for (var i = 0; i < objects.length; i++) {
      if (i != index) {
        objects[i].controller.selected = false;
        objects[i].controller.setSelected(false);
      }
    }
    objects[index].controller.selected = true;
    // objects[index].controller.rebuildWidget();
    objects[index].controller.setSelected(true);

    notifyListeners();
  }

  void setMapSelected() {
    saveObject();
    selectedIndex = -1;
    mapSelected = true;
    for (var i = 0; i < objects.length; i++) {
      objects[i].controller.selected = false;
      objects[i].controller.setSelected(false);
    }
    notifyListeners();
  }

  void saveObject() {
    if (selectedIndex > -1) {
      objects[selectedIndex].controller.save;
    }
  }

  void rotateObject(double angle) {
    if (selectedIndex > -1) {
      objects[selectedIndex].controller.rotate(angle);
    }
  }

  void addIcon(Icon icon) {
    if (selectedIndex > -1) {
      objects[selectedIndex].controller.icon = icon;
      objects[selectedIndex].controller.rebuildWidget();
    }
  }

  void removeIcon() {
    if (selectedIndex > -1) {
      objects[selectedIndex].controller.icon = null;
    }
  }

  void setWidth(double width) {
    if (selectedIndex > -1) {
      objects[selectedIndex].controller.setWidth(width);
    }
  }

  void setHeight(double height) {
    if (selectedIndex > -1) {
      objects[selectedIndex].controller.setHeight(height);
    }
  }

  void setX(double x) {
    if (selectedIndex > -1) {
      objects[selectedIndex].controller.setX(x);
    }
  }

  void setY(double y) {
    if (selectedIndex > -1) {
      objects[selectedIndex].controller.setY(y);
    }
  }

  void setName(String name) {
    if (selectedIndex > -1) {
      objects[selectedIndex].controller.name = name;
    }
  }

  void setDescription(String desc) {
    if (selectedIndex > -1) {
      objects[selectedIndex].controller.description = desc;
    }
  }

  Map<String, dynamic> exportAll(String mapId) {
    List<Map<String, dynamic>> result = [];
    for (var i = 0; i < objects.length; i++) {
      result.add(objects[i].controller.toJson());
    }

    var jsonRes = {'map_id': mapId, 'objects': result};

    return jsonRes;
  }

  void importAll(List<dynamic> data) {
    objects.clear();
    for (var i = 0; i < data.length; i++) {
      var currData = data[i] as Map<String, dynamic>;
      addObjectFromJson(currData);
    }
  }
}
