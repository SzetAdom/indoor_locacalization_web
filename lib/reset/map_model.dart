import 'package:indoor_localization_web/reset/map_point_model.dart';

class MapModel {
  String id;
  String name;

  List<MapPointModel> points;

  MapModel({
    required this.id,
    required this.name,
    required this.points,
    this.widthRigth = 0,
    this.widthLeft = 0,
    this.heightTop = 0,
    this.heightBottom = 0,
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

  double width = 500;
  double height = 500;

  double widthRigth;
  double widthLeft;
  double heightTop;
  double heightBottom;


  //starting point
  //list of objects
}
