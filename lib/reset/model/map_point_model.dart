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

  void draw(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    canvas.drawCircle(toOffset(), 5, paint);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'x': x,
      'y': y,
      'description': description,
      'icon': icon,
    };
  }

  MapPointModel copyWith({
    String? id,
    String? name,
    Color? color,
    double? x,
    double? y,
    String? description,
    String? icon,
  }) {
    return MapPointModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      x: x ?? this.x,
      y: y ?? this.y,
      description: description ?? this.description,
      icon: icon ?? this.icon,
    );
  }
}
