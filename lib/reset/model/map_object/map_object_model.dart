import 'package:flutter/cupertino.dart';
import 'package:indoor_localization_web/reset/model/map_object/map_object_data_model.dart';

class MapObjectModel {
  String id;
  Color color;
  int order;
  String name;
  String description;
  Icon? icon;

  MapObjectDataModel data;

  MapObjectModel({
    required this.id,
    required this.color,
    this.order = 0,
    required this.name,
    required this.description,
    required this.icon,
    required this.data,
  });

  copyWith({
    String? id,
    Color? color,
    int? order,
    String? name,
    String? description,
    Icon? icon,
    MapObjectDataModel? data,
  }) {
    return MapObjectModel(
      id: id ?? this.id,
      color: color ?? this.color,
      order: order ?? this.order,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      data: data ?? this.data,
    );
  }

  // copyWith(MapObjectDataModel data) {
  //   return MapObjectModel(
  //     id: id,
  //     color: color,
  //     order: order,
  //     name: name,
  //     description: description,
  //     icon: icon,
  //     data: data,
  //   );
  // }
}
