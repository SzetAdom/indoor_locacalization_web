import 'dart:ui';

import 'package:indoor_localization_web/reset/model/map_object_point_model.dart';

class WallObjectPointModel extends MapObjectPointModel{


  bool isDoor = false;

  WallObjectPointModel({
    required Offset point,
    required this.isDoor,
  }) : super(
          point: point,
        );

}