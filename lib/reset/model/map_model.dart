import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_objects/map_object_model.dart';
import 'package:json_annotation/json_annotation.dart';

class MapModel {
  String id;
  String name;

  List<MapObjectModel> objects;

  MapModel({
    required this.id,
    required this.name,
    required this.objects,
    this.extraWidthRight = 100,
    this.extraWidthLeft = 100,
    this.extraHeightTop = 100,
    this.extraHeightBottom = 100,
  });

  factory MapModel.fromJson(Map<String, dynamic> json) {
    var objects = json['objects'] as List;
    List<MapObjectModel> objectsList =
        objects.map((e) => MapObjectModel.fromJson(e)).toList();
    return MapModel(
      id: json['id'],
      name: json['name'],
      objects: objectsList,
      extraWidthRight: double.parse(json['extraWidthRight']),
      extraWidthLeft: double.parse(json['extraWidthLeft']),
      extraHeightTop: double.parse(json['extraHeightTop']),
      extraHeightBottom: double.parse(json['extraHeightBottom']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'objects': objects.map((e) => e.toJson()).toList(),
        'extraWidthRight': extraWidthRight,
        'extraWidthLeft': extraWidthLeft,
        'extraHeightTop': extraHeightTop,
        'extraHeightBottom': extraHeightBottom,
      };

  double baseWidth = 1000;
  double baseHeight = 1000;

  Size get baseSize => Size(baseWidth, baseHeight);

  void addExtraWidthRigth(double value) {
    if (value < 0 && widthRight < 30) return;
    extraWidthRight += value;
  }

  void addExtraWidthLeft(double value) {
    if (value < 0 && widthLeft < 30) return;
    extraWidthLeft += value;
  }

  void addExtraHeightTop(double value) {
    if (value < 0 && heightTop < 30) return;
    extraHeightTop += value;
  }

  void addExtraHeightBottom(double value) {
    if (value < 0 && heightBottom < 30) return;
    extraHeightBottom += value;
  }

  void removeExtraWidthRigth(double value) {
    if (value > 0 && widthRight < 30) return;
    extraWidthRight -= value;
  }

  void removeExtraWidthLeft(double value) {
    if (value > 0 && widthLeft < 30) return;
    extraWidthLeft -= value;
  }

  void removeExtraHeightTop(double value) {
    if (value > 0 && heightTop < 30) return;
    extraHeightTop -= value;
  }

  void removeExtraHeightBottom(double value) {
    if (value > 0 && heightBottom < 30) return;
    extraHeightBottom -= value;
  }

  double extraWidthRight;
  double extraWidthLeft;
  double extraHeightTop;
  double extraHeightBottom;

  double get width => baseWidth + extraWidthRight + extraWidthLeft;
  double get height => baseHeight + extraHeightTop + extraHeightBottom;
  double get widthRight => baseWidth / 2 + extraWidthRight;
  double get widthLeft => baseWidth / 2 + extraWidthLeft;
  double get heightTop => baseHeight / 2 + extraHeightTop;
  double get heightBottom => baseHeight / 2 + extraHeightBottom;

  //starting point
  //list of objects
}
