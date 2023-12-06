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
                  child: Text('Edit object:'),
                ),
                const SizedBox(
                  height: 10,
                ),
                MapItemEditorWidget(controller.selectedObject ??
                    WallObject(
                        id: '',
                        description: '',
                        name: '',
                        pointsRaw: [],
                        doors: []))
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
                          child: Text('Map objects:'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.map.objects.length,
                            itemBuilder: (context, index) {
                              MapObjectModel object =
                                  controller.map.objects[index];
                              return MapItemListTile(object);
                            }),
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
    return GestureDetector(
        onTap: () {
          context.read<MapEditorController>().selectObject(object.id);
        },
        child: Container(
          decoration: BoxDecoration(
            color: context.watch<MapEditorController>().selectedObjectId ==
                    object.id
                ? Colors.blue.withOpacity(0.2)
                : Colors.transparent,
          ),
          child: Text(object.name ?? object.id),
        ));
  }
}

class MapItemEditorWidget extends StatefulWidget {
  const MapItemEditorWidget(this.object, {Key? key}) : super(key: key);

  final WallObject object;

  @override
  State<MapItemEditorWidget> createState() => _MapItemEditorWidgetState();
}

class _MapItemEditorWidgetState extends State<MapItemEditorWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomTextInput(
            initText: widget.object.name,
            hintText: 'Name',
            onTextChanged: (value) {
              widget.object.name = value;
            },
            onTextSubmitted: () {
              context.read<MapEditorController>().updateObject(widget.object);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextInput(
            initText: widget.object.description,
            hintText: 'Description',
            multiline: true,
            onTextChanged: (value) {
              widget.object.description = value;
            },
            onTextSubmitted: () {
              context.read<MapEditorController>().updateObject(widget.object);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          // CustomTextInput(
          //   initText: widget.object.color?.value.toRadixString(16),
          //   hintText: 'Color',
          //   onTextChanged: (value) {
          //     widget.object.color = Color(int.parse(value, radix: 16));
          //   },
          //   onTextSubmitted: () {
          //     context.read<MapEditorController>().updateObject(widget.object);
          //   },
          // ),
          //points list
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
          //           widget.object.points.remove(point);
          //           context
          //               .read<MapEditorController>()
          //               .updateObject(widget.object);
          //         },
          //       );
          //     }),

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
                  onTextSubmitted: () {
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
              initText: widget.point.point.dx.toString(),
              hintText: 'x',
              onTextChanged: (value) {
                widget.point.point =
                    Offset(double.parse(value), widget.point.point.dy);
                widget.onPointChanged(widget.point);
              },
            ),
          ),
          //y input
          Expanded(
            child: CustomTextInput(
              initText: widget.point.point.dy.toString(),
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
