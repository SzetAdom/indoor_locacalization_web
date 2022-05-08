import 'dart:developer';

import 'package:flutter/material.dart';

class MapObjectController {
  late double width;
  late double height;
  late double x;
  late double y;
  late double angle;

  Color color = Colors.grey;
  late bool selected;

  late String name;
  late String description;
  Icon? icon;

  MapObjectController(
    this.name, {
    this.description = '',
    this.x = 0,
    this.y = 0,
    this.width = 100,
    this.height = 100,
    this.angle = 0,
    this.selected = false,
    required this.onSelect,
    required this.onChangeNotify,
  });

  MapObjectController.fromJson(
    Map<String, dynamic> imported, {
    required this.onSelect,
    required this.onChangeNotify,
  }) {
    log(imported.toString());
    name = imported['name'];
    description = imported['description'];
    x = imported['x'];
    y = imported['y'];
    width = imported['width'];
    height = imported['height'];
    angle = imported['angle'];
    if (imported['iconCodePoint'] != null && imported['iconFamily'] != null) {
      icon = Icon(IconData(imported['iconCodePoint'],
          fontFamily: imported['iconFamily']));
    }
    selected = false;
  }

  Function onSelect;
  Function onChangeNotify;
  void onChange(double width, double height, double x, double y, double angle) {
    this.width = width;
    this.height = height;
    this.x = x;
    this.y = y;
    this.angle = angle;
    onChangeNotify();
  }

  Function save = () {};
  Function rotate = (double angle) {};
  Function setWidth = (double width) {};
  Function setHeight = (double height) {};
  Function setX = (double x) {};
  Function setY = (double y) {};
  Function setSelected = (bool value) {};
  Function rebuildWidget = () {};

  void updateOnSelect(Function onSelect) {
    this.onSelect = onSelect;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'x': x,
      'y': y,
      'iconCodePoint': icon?.icon?.codePoint ?? '',
      'iconFamily': icon?.icon?.fontFamily ?? '',
      'width': width,
      'height': height,
      'angle': angle,
    };
  }
}
