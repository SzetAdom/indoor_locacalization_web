import 'package:flutter/material.dart';
import 'package:indoor_localization_web/controller/map_object_editor_controller.dart';
import 'package:indoor_localization_web/widget/map_editor/my_text_field.dart';
import 'package:provider/provider.dart';

class MapEditorControlPanel extends StatefulWidget {
  const MapEditorControlPanel({Key? key}) : super(key: key);

  @override
  State<MapEditorControlPanel> createState() => _MapEditorControlPanelState();
}

class _MapEditorControlPanelState extends State<MapEditorControlPanel> {
  @override
  void initState() {
    Provider.of<MapObjectEditorController>(context, listen: false).updatePanel =
        () {
      setState(() {});
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var controller =
        Provider.of<MapObjectEditorController>(context, listen: true);
    var asyncController =
        Provider.of<MapObjectEditorController>(context, listen: false);

    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.blueGrey,
            width: 400,
            child: SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Flexible(
                        child: MyTextField(
                            doubleOnly: true,
                            title: 'X',
                            value: controller.selectedMapObject?.data.x
                                    .toString() ??
                                '',
                            onChanged: (String value) {
                              if (controller.selectedMapObject != null) {
                                var newData = asyncController
                                    .selectedMapObject!.data
                                    .copyWith(x: double.parse(value));
                                asyncController.updateSelectedData(newData);
                              }
                            }),
                      ),
                      Flexible(
                        child: MyTextField(
                            doubleOnly: true,
                            title: 'Y',
                            value: controller.selectedMapObject?.data.y
                                    .toString() ??
                                '',
                            onChanged: (String value) {
                              if (controller.selectedMapObject != null) {
                                var newData = asyncController
                                    .selectedMapObject!.data
                                    .copyWith(y: double.parse(value));
                                asyncController.updateSelectedData(newData);
                              }
                            }),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Flexible(
                        child: MyTextField(
                            doubleOnly: true,
                            title: 'Width',
                            value: controller.selectedMapObject?.data.width
                                    .toString() ??
                                '',
                            onChanged: (String value) {
                              if (controller.selectedMapObject != null) {
                                var newData = asyncController
                                    .selectedMapObject!.data
                                    .copyWith(width: double.parse(value));
                                asyncController.updateSelectedData(newData);
                              }
                            }),
                      ),
                      Flexible(
                        child: MyTextField(
                            doubleOnly: true,
                            title: 'Height',
                            value: controller.selectedMapObject?.data.height
                                    .toString() ??
                                '',
                            onChanged: (String value) {
                              if (controller.selectedMapObject != null) {
                                var newData = asyncController
                                    .selectedMapObject!.data
                                    .copyWith(height: double.parse(value));
                                asyncController.updateSelectedData(newData);
                              }
                            }),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Expanded(
                          child: Slider(
                        divisions: 24,
                        min: 0,
                        max: 360,
                        label:
                            '${controller.selectedMapObject?.data.angle ?? 0}°',
                        inactiveColor: Colors.white,
                        activeColor: Colors.white,
                        value: controller.selectedMapObject?.data.angle ?? 0,
                        onChanged: (value) {
                          if (controller.selectedMapObject != null) {
                            var newData = asyncController
                                .selectedMapObject!.data
                                .copyWith(angle: value);
                            asyncController.updateSelectedData(newData);
                          }
                        },
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                            title: 'Name',
                            value:
                                controller.selectedMapObject?.name.toString() ??
                                    '',
                            onChanged: (String value) {
                              if (controller.selectedMapObject != null) {
                                var newModel = asyncController
                                    .selectedMapObject!
                                    .copyWith(name: value);
                                asyncController.updateSelectedModel(newModel);
                              }
                            }),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                          height: 300,
                          title: 'Description',
                          value: controller.selectedMapObject?.description
                                  .toString() ??
                              '',
                          onChanged: (String value) {
                            if (controller.selectedMapObject != null) {
                              var newModel = asyncController.selectedMapObject!
                                  .copyWith(description: value);
                              asyncController.updateSelectedModel(newModel);
                            }
                          }),
                    ),
                  ],
                ),
                if (controller.selectedIndex != -1)
                  GestureDetector(
                    onTap: () {
                      asyncController.deleteSelected();
                    },
                    child: Container(
                      width: 150,
                      height: 30,
                      margin: const EdgeInsets.all(10),
                      color: Colors.red,
                      child: const Center(
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            )),
          ),
        ),
      ],
    );
  }
}
