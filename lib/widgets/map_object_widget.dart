import 'dart:math';

import 'package:flutter/material.dart';
import 'package:indoor_localization_web/widgets/widget_controllers/map_object_widget_controller.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

const _size = 15.0;
const sizerSize = Size.square(_size);

var sizers = [
  Sizer(Alignment.topLeft, const EdgeInsets.only(left: 1, top: 1),
      const Offset(1, 1)),
  Sizer(Alignment.topRight, const EdgeInsets.only(right: 1, top: 1),
      const Offset(-1, 1)),
  Sizer(Alignment.bottomLeft, const EdgeInsets.only(left: 1, bottom: 1),
      const Offset(1, -1)),
  Sizer(Alignment.bottomRight, const EdgeInsets.only(right: 1, bottom: 1),
      const Offset(-1, -1)),
];

class Sizer {
  final Alignment alignment;
  final EdgeInsets insets;
  final Offset mask;
  Sizer(this.alignment, this.insets, this.mask);
}

class MapObjectWidget extends StatefulWidget {
  const MapObjectWidget({
    Key? key,
    required this.size,
    required this.onTap,
    required this.selected,
    required this.scale,
    required this.onSave,
    required this.mapObjectController,
    required this.angle,
    this.icon,
    this.offset,
    this.color = Colors.grey,
  }) : super(key: key);
  final Size size;
  final Offset? offset;
  final Color color;
  final Function(bool) onTap;
  final bool selected;
  final double scale;
  final Function(Rect, Offset, double) onSave;
  final MapObjectWidgetController mapObjectController;
  final double angle;
  final Icon? icon;

  @override
  _MapObjectWidgetState createState() {
    return _MapObjectWidgetState();
  }
}

class _MapObjectWidgetState extends State<MapObjectWidget>
    with TickerProviderStateMixin {
  late ValueNotifier<Rect> rect;
  Sizer currentSizer = Sizer(Alignment.center, EdgeInsets.zero, Offset.zero);
  late Rect savedRect;
  late Offset savedOffset;
  GlobalKey stackKey = GlobalKey();
  late ValueNotifier<double> angle;
  late ValueNotifier<Matrix4> matrix;
  ValueNotifier<bool> selected = ValueNotifier(false);
  double minWidth = 10;
  double minHeight = 10;

  @override
  void initState() {
    super.initState();
    initController();
  }

  void initController() {
    widget.mapObjectController.save = _save;
    widget.mapObjectController.rotate = _rotate;
    widget.mapObjectController.setWidth = (double width) {
      if (width < minWidth) {
        return false;
      }
      rect.value = Rect.fromLTWH(
        rect.value.left,
        rect.value.top,
        width,
        rect.value.height,
      );
      return true;
    };
    widget.mapObjectController.setHeight = (double height) {
      if (height < minHeight) {
        return false;
      }
      rect.value = Rect.fromLTWH(
        rect.value.left,
        rect.value.top,
        rect.value.width,
        height,
      );
      return true;
    };
    widget.mapObjectController.setX = (double x) {
      if (x < 0) {
        return false;
      }
      rect.value = Rect.fromLTWH(
        x,
        rect.value.top,
        rect.value.width,
        rect.value.height,
      );
      return true;
    };
    widget.mapObjectController.setY = (double y) {
      if (y < 0) {
        return false;
      }
      rect.value = Rect.fromLTWH(
        rect.value.left,
        y,
        rect.value.width,
        rect.value.height,
      );
      return true;
    };
  }

  void _init(Offset offset) {
    var realOffset = widget.offset ??
        Offset(offset.dx - widget.size.width / 2,
            offset.dy - widget.size.height / 2);

    // log('Offset: $realOffset');
    // log('Size: ${widget.size}');
    var r = realOffset & widget.size;
    rect = ValueNotifier(r);
    angle = ValueNotifier<double>(widget.angle);
    if (widget.offset == null) {
      widget.onSave(rect.value, realOffset, angle.value);
    }

    matrix = ValueNotifier(Matrix4.identity());

    selected = ValueNotifier(widget.selected);
    selected.addListener(() {
      widget.onTap(selected.value);
    });
  }

  void _save() {
    widget.onSave(rect.value, fetchOffsetFromMatrix(), angle.value);
  }

  void _rotate(double angle) {
    this.angle.value += angle * pi / 180;
  }

  Offset fetchOffsetFromMatrix() {
    var translationVector = matrix.value.getTranslation();
    Offset offsetFromMatrix =
        rect.value.topLeft.translate(translationVector.x, translationVector.y);
    return offsetFromMatrix;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selected.value = !selected.value;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          _init(constraints.biggest.center(Offset.zero));
          return MatrixGestureDetector(
            onMatrixUpdate: (m, tm, sm, rm) {
              matrix.value =
                  MatrixGestureDetector.compose(matrix.value, tm, sm, rm);
            },
            shouldTranslate: selected.value && true,
            shouldScale: selected.value && false,
            shouldRotate: selected.value && false,
            focalPointAlignment: Alignment.center,
            clipChild: false,
            child: AnimatedBuilder(
              animation: Listenable.merge([rect, matrix, selected, angle]),
              builder: (ctx, child) {
                return Transform(
                  transform: matrix.value,
                  child: Container(
                    // color: const Color.fromRGBO(200, 200, 200, 0.8),
                    child: Stack(
                      clipBehavior: Clip.none,
                      key: stackKey,
                      children: [
                        Positioned.fromRect(
                          rect: rect.value,
                          child: Transform.rotate(
                            angle: angle.value,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: widget.color,
                                  border: Border.all(
                                      color: (selected.value
                                          ? const Color.fromARGB(
                                              255, 16, 128, 219)
                                          : Colors.black),
                                      width: selected.value ? 3 : 0)),
                              child: Center(
                                child: widget.icon,
                              ),
                            ),
                          ),
                        ),
                        if (selected.value)
                          ...sizers.map((e) => _sizerBuilder(e, angle.value)),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _sizerBuilder(Sizer sizer, double angle) {
    var helperRect = sizer.alignment
        .inscribe(sizerSize * 1 / widget.scale, rect.value)
        .shift(sizer.mask * _size * -0.6);

    var finalRect = Offset(
          (helperRect.topLeft.dx * cos(angle * pi / 180)) -
              (helperRect.topLeft.dy * sin(angle * pi / 180)),
          (helperRect.topLeft.dx * sin(angle * pi / 180)) +
              (helperRect.topLeft.dy * cos(angle * pi / 180)),
        ) &
        helperRect.size;

    var centerRect = Alignment.center.inscribe(sizerSize, rect.value);

    var interpolated = Rect.lerp(finalRect, centerRect, 0);
    return Positioned.fromRect(
      rect: interpolated ?? Rect.zero,
      child: GestureDetector(
        onPanStart: (details) => _panStart(sizer, details),
        onPanUpdate: _panUpdate,
        onPanEnd: _panEnd,
        child: Container(
          decoration: const ShapeDecoration(
            shape: CircleBorder(),
            color: Color.fromARGB(255, 16, 128, 219),
          ),
        ),
      ),
    );
  }

  _panStart(Sizer sizer, DragStartDetails details) {
    currentSizer = sizer;
    savedRect = rect.value;
    savedOffset = _invertedOffset(details.globalPosition);
  }

  _panUpdate(DragUpdateDetails details) {
    var delta = savedOffset - _invertedOffset(details.globalPosition);

    var leftInset = currentSizer.insets.left * delta.dx * currentSizer.mask.dx;
    var topInset = currentSizer.insets.top * delta.dy * currentSizer.mask.dy;
    var rightInset =
        currentSizer.insets.right * delta.dx * currentSizer.mask.dx;
    var bottomInset =
        currentSizer.insets.bottom * delta.dy * currentSizer.mask.dy;

    var insets = EdgeInsets.fromLTRB(
      leftInset,
      topInset,
      rightInset,
      bottomInset,
    );
    var newRectValue = insets.inflateRect(savedRect);
    if (newRectValue.width > minWidth && newRectValue.height > minHeight) {
      rect.value = newRectValue;
    }
  }

  _panEnd(DragEndDetails details) {
    currentSizer = Sizer(Alignment.center, EdgeInsets.zero, Offset.zero);
  }

  Offset _invertedOffset(Offset offset) {
    RenderBox rb = stackKey.currentContext?.findRenderObject() as RenderBox;
    return rb.globalToLocal(offset);
  }
}
