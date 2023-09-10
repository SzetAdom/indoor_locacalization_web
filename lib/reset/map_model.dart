import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_point_model.dart';

class MapModel {
  String id;
  String name;

  List<MapPointModel> points;

  MapModel({
    required this.id,
    required this.name,
    required this.points,
    this.extraWidthRigth = 100,
    this.extraWidthLeft = 100,
    this.extraHeightTop = 100,
    this.extraHeightBottom = 100,
  });

  factory MapModel.fromJson(Map<String, dynamic> json) {
    return MapModel(
      id: json['id'],
      name: json['name'],
      points: json['points']
          .map<MapPointModel>((point) => MapPointModel.fromJson(point))
          .toList(),
    );
  }

  double baseWidth = 500;
  double baseHeight = 500;

  Size get baseSize => Size(baseWidth, baseHeight);

  double extraWidthRigth;

  void setExtraWidthRigth(double value) {
    if (widthRight < 30) return;
    extraWidthRigth = value;
  }

  double extraWidthLeft;
  void setExtraWidthLeft(double value) {
    if (widthLeft < 30) return;
    extraWidthLeft = value;
  }

  double extraHeightTop;
  void setExtraHeightTop(double value) {
    if (heightTop < 30) return;
    extraHeightTop = value;
  }

  double extraHeightBottom;
  void setExtraHeightBottom(double value) {
    if (heightBottom < 30) return;
    extraHeightBottom = value;
  }

  double get width => baseWidth + extraWidthRigth + extraWidthLeft;
  double get height => baseHeight + extraHeightTop + extraHeightBottom;
  double get widthRight => baseWidth / 2 + extraWidthRigth;
  double get widthLeft => baseWidth / 2 + extraWidthLeft;
  double get heightTop => baseHeight / 2 + extraHeightTop;
  double get heightBottom => baseHeight / 2 + extraHeightBottom;

  //starting point
  //list of objects
}
