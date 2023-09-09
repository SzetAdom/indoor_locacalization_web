import 'package:indoor_localization_web/reset/map_point_model.dart';

class MapObjectModel {
  String id;
  String? name;
  String? color;
  String? icon;
  String? description;
  List<MapPointModel> points;

  MapObjectModel({
    required this.id,
    this.name,
    this.color,
    this.icon,
    this.description,
    required this.points,
  });

  factory MapObjectModel.fromJson(Map<String, dynamic> json) {
    return MapObjectModel(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      icon: json['icon'],
      description: json['description'],
      points: json['points']
          .map<MapPointModel>((point) => MapPointModel.fromJson(point))
          .toList(),
    );
  }
  
}
