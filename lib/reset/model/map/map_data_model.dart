import 'package:indoor_localization_web/reset/model/map_object/map_object_model.dart';

class MapDataModel {
  String id;
  String name;
  String description;
  String image;
  int selectedIndex;
  List<MapObjectModel> objects;

  MapDataModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.objects,
    this.selectedIndex = -1,
  });
}
