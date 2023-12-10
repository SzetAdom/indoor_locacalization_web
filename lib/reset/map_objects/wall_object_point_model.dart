import 'dart:ui';

import 'package:indoor_localization_web/reset/model/map_object_point_model.dart';

class WallObjectPointModel extends MapObjectPointModel {
  WallObjectPointModel({
    required Offset point,
  }) : super(
          point: point,
        );

  factory WallObjectPointModel.fromJson(Map<String, dynamic> json) =>
      WallObjectPointModel(
        point: Offset(double.parse(json['x']), double.parse(json['y'])),
      );

  @override
  Map<String, dynamic> toJson() => {
        'x': point.dx.toString(),
        'y': point.dy.toString(),
      };
}
