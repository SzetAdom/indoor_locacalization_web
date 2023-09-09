import 'package:flutter/material.dart';

class MapPointModel {
  final String id;
  String? name;
  Color? color;
  double x;
  double y;
  String description;
  String? icon;

  MapPointModel({
    required this.id,
    this.name,
    this.color,
    required this.x,
    required this.y,
    required this.description,
    this.icon,
  });

  factory MapPointModel.fromJson(Map<String, dynamic> json) {
    return MapPointModel(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      x: json['x'],
      y: json['y'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  Offset toOffset() {
    return Offset(
      x,
      y,
    );
  }
}
