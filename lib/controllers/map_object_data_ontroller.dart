import 'package:flutter/cupertino.dart';
import 'package:indoor_localization_web/models/map_object.dart';

class MapObjectDataController extends ChangeNotifier {
  List<MapObjectData> objects = [];
  int selectedIndex = -1;
  double moveSpeed = 10;
  bool mapSelected = true;

  MapObjectDataController();

  void addObject(MapObjectData object) {
    objects.add(object);
    object.setOnTap((selected) {
      if (selected) {
        setSelected(objects.indexOf(object));
      } else {
        setMapSelected();
      }
    });
    notifyListeners();
  }

  void removeObject(MapObjectData object) {
    objects.remove(object);
    notifyListeners();
  }

  void removeAll() {
    objects.clear();
    notifyListeners();
  }

  void setSelected(int index) {
    mapSelected = false;
    saveObject();
    selectedIndex = index;
    for (var i = 0; i < objects.length; i++) {
      objects[i].selected = false;
    }
    objects[index].selected = true;
    notifyListeners();
  }

  void setMapSelected() {
    saveObject();
    selectedIndex = -1;
    mapSelected = true;
    for (var i = 0; i < objects.length; i++) {
      objects[i].selected = false;
    }
    selectedIndex = -1;
    notifyListeners();
  }

  void saveObject() {
    if (selectedIndex > -1) {
      objects[selectedIndex].saveWidget();
    }
  }

  void rotateObject(double angle) {
    if (selectedIndex > -1) {
      objects[selectedIndex].rotate(angle);
    }
  }

  void addIcon(Icon icon) {
    if (selectedIndex > -1) {
      objects[selectedIndex].icon = icon;
      objects[selectedIndex].buildWidget();
    }
  }

  void removeIcon() {
    if (selectedIndex > -1) {
      objects[selectedIndex].icon = null;
    }
  }

  MapObjectData? getSelected() {
    if (selectedIndex > -1) {
      return objects[selectedIndex];
    }
    return null;
  }

  void setWidth(double width) {
    if (selectedIndex > -1) {
      objects[selectedIndex].setWidth(width);
    }
  }

  void setHeight(double height) {
    if (selectedIndex > -1) {
      objects[selectedIndex].setHeight(height);
    }
  }

  void setX(double x) {
    if (selectedIndex > -1) {
      objects[selectedIndex].setX(x);
    }
  }

  void setY(double y) {
    if (selectedIndex > -1) {
      objects[selectedIndex].setY(y);
    }
  }
}
