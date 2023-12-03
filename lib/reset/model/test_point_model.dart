import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/model/map_point_model.dart';

class TestPointModel extends MapPointModel {
  TestPointModel(
      {required String id,
      required this.name,
      required Offset point,
      Color? color = Colors.yellow})
      : super(
          id: id,
          x: point.dx,
          y: point.dy,
          color: color,
        );

  String name;

  factory TestPointModel.fromJson(Map<String, dynamic> json) => TestPointModel(
        point: Offset(double.parse(json['x'].toString()),
            double.parse(json['y'].toString())),
        id: json['id'],
        name: json['name'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'x': super.x.toString(),
        'y': super.y.toString(),
        'id': id,
        'name': name,
      };
}
