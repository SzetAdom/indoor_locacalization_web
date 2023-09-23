import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_point_model.dart';

abstract class MapObjectInterface {
  void addPoint(MapPointModel point);
  void removePoint(MapPointModel point);
  void movePointBy(MapPointModel point, Offset offset);
  void movePointTo(MapPointModel point, Offset offset);
  void draw(Canvas canvas, Size size);
}

class MapObjectModel implements MapObjectInterface {
  String id;
  String? name;
  Color? color;
  String? icon;
  String? description;
  List<MapPointModel> points;

  MapObjectModel({
    required this.id,
    this.name,
    this.color,
    this.icon,
    this.description,
    required this.points,
  });

  MapObjectModel copyWith({
    String? id,
    String? name,
    Color? color,
    String? icon,
    String? description,
    List<MapPointModel>? points,
  }) {
    return MapObjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'icon': icon,
      'description': description,
      'points': points.map((e) => e.toJson()).toList(),
    };
  }

  factory MapObjectModel.fromJson(Map<String, dynamic> json) {
    return MapObjectModel(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      icon: json['icon'],
      description: json['description'],
      points: (json['points'] as List)
          .map((e) => MapPointModel.fromJson(e))
          .toList(),
    );
  }

  @override
  void addPoint(MapPointModel point) {
    points.add(point);
  }

  @override
  void removePoint(MapPointModel point) {
    points.remove(point);
  }

  @override
  void movePointBy(MapPointModel point, Offset offset) {
    point.x += offset.dx;
    point.y += offset.dy;
  }

  @override
  void movePointTo(MapPointModel point, Offset offset) {
    point.x = offset.dx;
    point.y = offset.dy;
  }

  @override
  void draw(Canvas canvas, Size size) {
    for (var point in points) {
      point.draw(canvas, size);
    }
  }
}
