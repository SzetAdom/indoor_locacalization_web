class MapArgs {
  String id;
  String userId;
  String name;
  double width;
  double height;

  MapArgs({
    required this.height,
    required this.width,
    required this.name,
    required this.id,
    required this.userId,
  });

  factory MapArgs.fromJson(Map<String, dynamic> json) {
    return MapArgs(
      name: json['name'] ?? '',
      width: json['width'] ?? 500,
      height: json['height'] ?? 500,
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'width': width,
      'height': height,
      'id': id,
      'user_id': userId,
    };
  }
}
