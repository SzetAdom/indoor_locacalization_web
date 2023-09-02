import 'package:flutter/material.dart';
import 'package:indoor_localization_web/controller/map_object_editor_controller.dart';
import 'package:provider/provider.dart';

class ObjectListWidget extends StatefulWidget {
  const ObjectListWidget({Key? key}) : super(key: key);

  @override
  State<ObjectListWidget> createState() => _ObjectListWidgetState();
}

class _ObjectListWidgetState extends State<ObjectListWidget> {
  @override
  Widget build(BuildContext context) {
    var controller =
        Provider.of<MapObjectEditorController>(context, listen: true);
    var asyncController =
        Provider.of<MapObjectEditorController>(context, listen: false);
    return Container(
      margin: const EdgeInsets.all(20),
      color: Colors.white,
      child: ListView.builder(
        itemBuilder: (context, index) => Container(
          height: 20,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(
                  color: controller.selectedMapObject == null
                      ? Colors.transparent
                      : index == controller.selectedIndex
                          ? Colors.blueGrey
                          : Colors.transparent)),
          child: GestureDetector(
            onTap: () {
              asyncController.selectObject(index, true);
            },
            child: Container(
              child: Text(controller.mapDataModel.objects[index].name),
            ),
          ),
        ),
        itemCount: controller.mapDataModel.objects.length,
      ),
    );
  }
}
