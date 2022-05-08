// import 'package:flutter/material.dart';
// import 'package:indoor_localization_web/widgets/map_object_widget.dart';
// import 'package:indoor_localization_web/widgets/widget_controllers/map_object_widget_controller.dart';

// class MapObjectData {
//   Rect? rect;
//   Size initSize;
//   Color color;
//   bool selected;
//   Offset? offset;
//   double angle = 0;
//   late ValueNotifier<Widget> widget = ValueNotifier(Container());
//   Function onTap = (bool selected) {};
//   MapObjectWidgetController controller = MapObjectWidgetController();
//   String name;
//   Icon? icon;

//   setOnTap(Function(bool selected) onTap) {
//     this.onTap = onTap;
//   }

//   saveWidget() {
//     controller.save();
//   }

//   rotate(double angle) {
//     controller.rotate(angle);
//   }

//   setWidth(double width) {
//     controller.setWidth(width);
//   }

//   setHeight(double height) {
//     controller.setHeight(height);
//   }

//   setX(double x) {
//     controller.setX(x);
//   }

//   setY(double y) {
//     controller.setY(y);
//   }

//   MapObjectData(this.name,
//       {required this.initSize,
//       this.color = Colors.grey,
//       this.selected = false});

//   void buildWidget() {
//     widget.value = MapObjectWidget(
//       controller: controller,
//       color: color,
//       onTap: (bool selected) {
//         this.selected = selected;
//         onTap(selected);
//       },
//       offset: offset,
//       angle: angle,
//       selected: selected,
//       scale: 1.0,
//       onSave: (Rect rect, Offset offset, double angle) {
//         this.rect = rect;
//         this.offset = offset;
//         this.angle = angle;
//       },
//       icon: icon,
//     );
//   }
// }
