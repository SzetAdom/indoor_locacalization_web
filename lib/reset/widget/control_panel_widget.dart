import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_editor_controller.dart';
import 'package:provider/provider.dart';

class ControlPanelWidget extends StatefulWidget {
  const ControlPanelWidget({Key? key}) : super(key: key);

  @override
  State<ControlPanelWidget> createState() => _ControlPanelWidgetState();
}

class _ControlPanelWidgetState extends State<ControlPanelWidget> {
  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<MapEditorController>(context);
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.25,
      child: Column(
        children: [
          const SizedBox(
            child: Text('Control Panel'),
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: controller.map.objects.length,
              itemBuilder: (context, index) {
                var object = controller.map.objects[index];
                return ListTile(
                  title: Text(object.name ?? object.id),
                  onTap: () {
                    controller.selectObject(object.id);
                  },
                );
              })
        ],
      ),
    );
  }
}
