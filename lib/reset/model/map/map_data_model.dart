import 'package:indoor_localization_web/reset/model/map_object/map_object_model.dart';

class MapDataModel {
  String id;
  String userId;
  String name;
  String description;
  String image;
  List<MapObjectModel> objects;
  double width;
  double height;

  MapDataModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.image,
    required this.objects,
    required this.width,
    required this.height,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'objects': objects.map((e) => e.toJson()).toList(),
      'width': width,
      'height': height,
      'user_id': userId,
    };
  }
}
