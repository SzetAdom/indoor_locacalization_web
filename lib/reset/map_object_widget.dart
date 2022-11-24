import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/model/map_object_model.dart';

class MapObjecWidget extends StatelessWidget {
  const MapObjecWidget(this.mapObjectModel, {required this.child, Key? key})
      : super(key: key);

  final MapObjectModel mapObjectModel;
  final Widget Function(Widget child) child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: Rect.fromCenter(
        center: Offset(mapObjectModel.data.x, mapObjectModel.data.y),
        width: mapObjectModel.data.width,
        height: mapObjectModel.data.height,
      ),
      child: Transform.rotate(
        angle: mapObjectModel.data.angleInRadiant,
        child: child.call(Container(
          color: mapObjectModel.color,
          child: Center(
            child: mapObjectModel.icon,
          ),
        )),
      ),
    );
  }
}
