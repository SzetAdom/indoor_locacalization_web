import 'package:indoor_localization_web/reset/map_point_model.dart';

class MapModel {
  String id;
  String name;

  List<MapPointModel> points;

  MapModel({
    required this.id,
    required this.name,
    required this.points,
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

  //starting point
  //list of objects
}
