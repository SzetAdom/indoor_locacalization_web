import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/model/map_object_metadata.dart';

class SizerWidget extends StatefulWidget {
  const SizerWidget(
      {required this.mapObjectDataModel,
      required this.alignment,
      required this.onResize,
      this.size = const Size(15, 15),
      required this.stackKey,
      Key? key})
      : super(key: key);

  final MapObjectDataModel mapObjectDataModel;
  final Size size;
  final Alignment alignment;
  final Offset offset = const Offset(10, 10);
  final Function(MapObjectDataModel mapObjectDataModel) onResize;
  final GlobalKey stackKey;

  Offset getAlignMultipliers() {
    var x = 0.0;
    var y = 0.0;
    if (alignment == Alignment.topLeft) {
      x = -1;
      y = -1;
    } else if (alignment == Alignment.topRight) {
      x = 1;
      y = -1;
    } else if (alignment == Alignment.bottomLeft) {
      x = -1;
      y = 1;
    } else if (alignment == Alignment.bottomRight) {
      x = 1;
      y = 1;
    }
    return Offset(x, y);
  }

  @override
  State<SizerWidget> createState() => _SizerWidgetState();
}

class _SizerWidgetState extends State<SizerWidget> {
  late Alignment alignmnetWithoutOffset;
  late Rect sizer;
  late Rect sizerWithoutOffset;

  late EdgeInsets _edgeInsets;

  late Offset savedOffset;

  Alignment getAlignMent() {
    var mulitplier = widget.getAlignMultipliers();
    var x = mulitplier.dx;
    var y = mulitplier.dy;
    var angle = widget.mapObjectDataModel.angleInRadiant;

    double xOffsetPercentage =
        ((widget.mapObjectDataModel.width / 2) + widget.offset.dx) /
            (widget.mapObjectDataModel.width / 2);
    double yOffsetPercentage =
        ((widget.mapObjectDataModel.height / 2) + widget.offset.dy) /
            (widget.mapObjectDataModel.height / 2);

    ///Az offset itt nem eltolást(maszkot) jelent, hanem mint vektor használjuk
    Offset rotatedEdge = rotate(x: x, y: y, angle: angle);

    alignmnetWithoutOffset = Alignment(rotatedEdge.dx, rotatedEdge.dy);

    x = x * xOffsetPercentage;
    y = y * yOffsetPercentage;

    rotatedEdge = rotate(x: x, y: y, angle: angle);
    var res = Alignment(rotatedEdge.dx, rotatedEdge.dy);
    return res;
  }

  Offset rotate({required double x, required double y, required angle}) {
    var rotatedX = x * cos(angle) - y * sin(angle);
    var rotatedY = x * sin(angle) + y * cos(angle);
    return Offset(rotatedX, rotatedY);
  }

  @override
  void initState() {
    super.initState();
    if (widget.alignment == Alignment.topLeft) {
      _edgeInsets = const EdgeInsets.only(top: 1, left: 1);
    } else if (widget.alignment == Alignment.topRight) {
      _edgeInsets = const EdgeInsets.only(top: 1, right: 1);
    } else if (widget.alignment == Alignment.bottomLeft) {
      _edgeInsets = const EdgeInsets.only(bottom: 1, left: 1);
    } else if (widget.alignment == Alignment.bottomRight) {
      _edgeInsets = const EdgeInsets.only(bottom: 1, right: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    sizer =
        getAlignMent().inscribe(widget.size, widget.mapObjectDataModel.rect);
    sizerWithoutOffset = alignmnetWithoutOffset.inscribe(
        widget.size, widget.mapObjectDataModel.rect);

    return Positioned.fromRect(
      rect: sizer,
      child: GestureDetector(
        onPanStart: (details) => _panStart(details),
        onPanUpdate: _panUpdate,
        onPanEnd: _panEnd,
        child: Container(
          decoration: ShapeDecoration(
            shape: const CircleBorder(),
            color: widget.alignment == Alignment.topLeft
                ? Colors.blue
                : widget.alignment == Alignment.topRight
                    ? Colors.red
                    : widget.alignment == Alignment.bottomLeft
                        ? Colors.green
                        : widget.alignment == Alignment.bottomRight
                            ? Colors.yellow
                            : Colors.black,
          ),
        ),
      ),
    );
  }

  _panStart(DragStartDetails details) {
    dev.log('drag started');
    // savedOffset = _stackOffset(details.globalPosition);
  }

  _panUpdate(DragUpdateDetails details) {
    var delta = details.delta;
    dev.log('delta: $delta');

    /// delta = (old-details) * -1
    var newX = widget.mapObjectDataModel.x + delta.dx;
    var newY = widget.mapObjectDataModel.y + delta.dy;
    var newWidth = widget.mapObjectDataModel.width +
        delta.dx * widget.getAlignMultipliers().dx * 2;
    var newHeight = widget.mapObjectDataModel.height +
        delta.dy * widget.getAlignMultipliers().dy * 2;
    var newMapObjectData = MapObjectDataModel(
        x: newX,
        y: newY,
        width: newWidth,
        height: newHeight,
        angle: widget.mapObjectDataModel.angle);
    widget.onResize(newMapObjectData);

    // var leftInset = _edgeInsets.left * delta.dx;
    // var rightInset = _edgeInsets.right * delta.dx;
    // var topInset = _edgeInsets.top * delta.dy;
    // var bottomInset = _edgeInsets.bottom * delta.dy;

    // var insets = EdgeInsets.fromLTRB(
    //   leftInset,
    //   topInset,
    //   rightInset,
    //   bottomInset,
    // );
    // var newRectValue = insets.inflateRect(widget.mapObjectDataModel.localRect);
    // newRectValue.center = widget.mapObjectDataModel.localRect.center;
    // dev.log('oldRect: ${widget.mapObjectDataModel.localRect}');
    // dev.log('newRect: $newRectValue');
    // widget.onResize(newRectValue);
  }

  _panEnd(DragEndDetails details) {
    dev.log('drag ended');
  }

  // Offset _stackOffset(Offset offset) {
  //   RenderBox rb =
  //       widget.stackKey.currentContext?.findRenderObject() as RenderBox;
  //   return rb.globalToLocal(offset);
  // }
}
