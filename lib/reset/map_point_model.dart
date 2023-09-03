import 'package:flutter/material.dart';

class MapPointModel {
  final String id;
  final String? name;
  final Color? color;
  final double? x;
  final double? y;
  final String description;
  final String? icon;

  MapPointModel({
    required this.id,
    this.name,
    this.color,
    this.x,
    this.y,
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
}
