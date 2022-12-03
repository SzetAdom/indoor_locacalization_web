import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:indoor_localization_web/reset/controller/map_object_editor_controller.dart';
import 'package:indoor_localization_web/reset/widget/map_editor/my_text_field.dart';
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
            width: 400.w,
            child: SingleChildScrollView(
                child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 400.w,
                      height: 100.h,
                      color: Colors.blueGrey,
                      child: const Center(
                        child: Text(
                          'Map editor',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Flexible(
                        child: MyTextField(
                            doubleOnly: true,
                            title: 'X',
                            value: controller.selectedMapObject != null
                                ? controller.selectedMapObject!.data.x
                                    .toString()
                                : '',
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
                            title: 'y',
                            value: '13',
                            onChanged: (String value) {}),
                      ),
                    ],
                  ),
                )
              ],
            )),
          ),
        ),
      ],
    );
  }
}
