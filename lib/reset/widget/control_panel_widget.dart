import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/map_editor_controller.dart';
import 'package:indoor_localization_web/reset/map_objects/map_object_model.dart';
import 'package:indoor_localization_web/reset/map_objects/wall_object.dart';
import 'package:indoor_localization_web/reset/model/map_object_point_model.dart';
import 'package:indoor_localization_web/reset/widget/custom_text_input.dart';
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
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Flexible(
              child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ]),
            child: Column(
              children: [
                const SizedBox(
                  child: Text('Térkép elem szerkesztése:'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: MapItemEditorWidget(controller.selectedObject ??
                      WallObjectModel(
                          id: '',
                          description: '',
                          name: '',
                          pointsRaw: [],
                          doors: [])),
                )
              ],
            ),
          )),
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ]),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(
                          child: Text('Térkép elemek:'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.map.objects.length,
                              itemBuilder: (context, index) {
                                MapObjectModel object =
                                    controller.map.objects[index];
                                return MapItemListTile(object);
                              }),
                        ),
                        //add new object button
                        ElevatedButton(
                          onPressed: () {
                            controller.addNewObject();
                          },
                          child: const Text('Új elem hozzáadása'),
                        ),
                      ],
                    ),
                  ),
                  // Expanded(child: Container()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MapItemListTile extends StatelessWidget {
  const MapItemListTile(this.object, {Key? key}) : super(key: key);

  final MapObjectModel object;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
              onTap: () {
                context.read<MapEditorController>().selectObject(object.id);
              },
              child: Container(
                decoration: BoxDecoration(
                  color:
                      context.watch<MapEditorController>().selectedObjectId ==
                              object.id
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.transparent,
                ),
                child: Text(object.name ?? object.id),
              )),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            context.read<MapEditorController>().removeObject(object.id);
          },
        ),
      ],
    );
  }
}

class MapItemEditorWidget extends StatefulWidget {
  const MapItemEditorWidget(this.object, {Key? key}) : super(key: key);

  final WallObjectModel object;

  @override
  State<MapItemEditorWidget> createState() => _MapItemEditorWidgetState();
}

class _MapItemEditorWidgetState extends State<MapItemEditorWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextInput(
            initText: widget.object.id,
            hintText: 'Id',
            multiline: true,
            onTextChanged: (value) {
              widget.object.id = value;
            },
            onTextSubmitted: (value) {
              context.read<MapEditorController>().updateObject(widget.object);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextInput(
            initText: widget.object.name,
            hintText: 'Név',
            onTextChanged: (value) {
              widget.object.name = value;
            },
            onTextSubmitted: (value) {
              context.read<MapEditorController>().updateObject(widget.object);
            },
          ),

          const SizedBox(
            height: 10,
          ),
          //rotating with slider and text input
          Row(
            children: [
              Expanded(
                child: Slider(
                  max: 360,
                  min: -360,
                  value: widget.object.angle,
                  onChanged: (value) {
                    setState(() {
                      widget.object.angle = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: CustomTextInput(
                  initText: widget.object.angle.toString(),
                  hintText: 'Rotation',
                  onTextChanged: (value) {
                    // angle in degrees
                    widget.object.angle = double.parse(value);
                  },
                  onTextSubmitted: (value) {
                    context
                        .read<MapEditorController>()
                        .updateObject(widget.object);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          // points list
          // ListView.builder(
          //     shrinkWrap: true,
          //     itemCount: widget.object.points.length,
          //     itemBuilder: (context, index) {
          //       MapObjectPointModel point = widget.object.points[index];
          //       return PointEditorListItem(
          //         point: point,
          //         onPointChanged: (point) {
          //           context
          //               .read<MapEditorController>()
          //               .updateObject(widget.object);
          //         },
          //         onPointRemoved: (point) {
          //           var object = WallObjectModel.copy(widget.object);
          //           object.removePoint(point);
          //           context.read<MapEditorController>().updateObject(object);
          //         },
          //       );
          //     }),
          //add new point button

          ElevatedButton(
            onPressed: () {
              widget.object.addPoint(MapObjectPointModel(
                  point:
                      widget.object.points.last.point + const Offset(10, 10)));
              context.read<MapEditorController>().updateObject(widget.object);
            },
            child: const Text('Új pont hozzáadása'),
          ),

          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class PointEditorListItem extends StatefulWidget {
  const PointEditorListItem(
      {required this.point,
      required this.onPointChanged,
      required this.onPointRemoved,
      Key? key})
      : super(key: key);

  final MapObjectPointModel point;
  final Function(MapObjectPointModel) onPointChanged;
  final Function(MapObjectPointModel) onPointRemoved;

  @override
  State<PointEditorListItem> createState() => _PointEditorListItemState();
}

class _PointEditorListItemState extends State<PointEditorListItem> {
  late double x;
  late double y;

  @override
  void initState() {
    super.initState();
    x = widget.point.point.dx;
    y = widget.point.point.dy;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //x input
          Expanded(
            child: CustomTextInput(
              initText: x.toString(),
              hintText: 'x',
              onTextChanged: (value) {
                widget.point.point =
                    Offset(double.parse(value), widget.point.point.dy);
                widget.onPointChanged(widget.point);
              },
              onTextSubmitted: (value) {
                widget.point.point =
                    Offset(double.parse(value), widget.point.point.dy);
                widget.onPointChanged(widget.point);
              },
            ),
          ),
          //y input
          Expanded(
            child: CustomTextInput(
              initText: y.toString(),
              hintText: 'y',
              onTextChanged: (value) {
                widget.point.point =
                    Offset(widget.point.point.dx, double.parse(value));
                widget.onPointChanged(widget.point);
              },
            ),
          ),
          //remove button
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              widget.onPointRemoved(widget.point);
            },
          ),
        ],
      ),
    );
  }
}
