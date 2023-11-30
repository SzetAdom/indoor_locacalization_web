import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_object_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'map_model.g.dart';

@JsonSerializable()
class MapModel {
  String id;
  String name;

  List<MapObjectModel> objects;

  MapModel({
    required this.id,
    required this.name,
    required this.objects,
    this.extraWidthRigth = 100,
    this.extraWidthLeft = 100,
    this.extraHeightTop = 100,
    this.extraHeightBottom = 100,
  });

  factory MapModel.fromJson(Map<String, dynamic> json) =>
      _$MapModelFromJson(json);

  Map<String, dynamic> toJson() => _$MapModelToJson(this);

  double baseWidth = 1000;
  double baseHeight = 1000;

  Size get baseSize => Size(baseWidth, baseHeight);

  void addExtraWidthRigth(double value) {
    if (value < 0 && widthRight < 30) return;
    extraWidthRigth += value;
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
    extraWidthRigth -= value;
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

  double extraWidthRigth;
  double extraWidthLeft;
  double extraHeightTop;
  double extraHeightBottom;

  double get width => baseWidth + extraWidthRigth + extraWidthLeft;
  double get height => baseHeight + extraHeightTop + extraHeightBottom;
  double get widthRight => baseWidth / 2 + extraWidthRigth;
  double get widthLeft => baseWidth / 2 + extraWidthLeft;
  double get heightTop => baseHeight / 2 + extraHeightTop;
  double get heightBottom => baseHeight / 2 + extraHeightBottom;

  //starting point
  //list of objects
}
