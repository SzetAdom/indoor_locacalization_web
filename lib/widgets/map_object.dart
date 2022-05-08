import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:indoor_localization_web/controllers/map_object_controller.dart';
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

class MapObject extends StatefulWidget {
  const MapObject({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final MapObjectController controller;

  @override
  _MapObjectState createState() {
    return _MapObjectState();
  }
}

class _MapObjectState extends State<MapObject> with TickerProviderStateMixin {
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
  ValueNotifier<int> notifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    //bind controller actions
    dev.log('initState');
    initController();
  }

  void initController() {
    widget.controller.rebuildWidget = () {
      notifier.value++;
    };
    widget.controller.save = _save;
    widget.controller.rotate = _rotate;
    widget.controller.setSelected = (bool value) {
      selected.value = value;
    };
    widget.controller.setWidth = (double width) {
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
    widget.controller.setHeight = (double height) {
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
    widget.controller.setX = (double x) {
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
    widget.controller.setY = (double y) {
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

  void _init() {
    //init Object data by given controller
    var r = Offset(widget.controller.width, widget.controller.height) &
        Size(widget.controller.width, widget.controller.height);
    rect = ValueNotifier(r);
    angle = ValueNotifier<double>(widget.controller.angle);
    selected = ValueNotifier(widget.controller.selected);

    matrix = ValueNotifier(Matrix4.identity());

    //Add listener to controller
    rect.addListener(() {
      _save();
    });
    matrix.addListener(() {
      _save();
    });
    angle.addListener(() {
      _save();
    });
  }

  void _save() {
    var offset = calculateOffsetFromMatrix();
    widget.controller.onChange(rect.value.width, rect.value.height, offset.dx,
        offset.dy, angle.value * 180 / pi);
  }

  void _rotate(double angle) {
    this.angle.value = angle * pi / 180;
  }

  Offset calculateOffsetFromMatrix({Matrix4? matrixIn}) {
    matrixIn ??= matrix.value;
    var translationVector = matrix.value.getTranslation();
    Offset offsetFromMatrix =
        rect.value.topLeft.translate(translationVector.x, translationVector.y);
    return offsetFromMatrix;
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return GestureDetector(
      onTap: () {
        selected.value = !selected.value;
        widget.controller.onSelect(selected.value);
        _save();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation:
                Listenable.merge([rect, matrix, selected, angle, notifier]),
            builder: (ctx, child) {
              return MatrixGestureDetector(
                onMatrixUpdate: (m, tm, sm, rm) {
                  var newMatrix =
                      MatrixGestureDetector.compose(matrix.value, tm, sm, rm);
                  var newOffset =
                      calculateOffsetFromMatrix(matrixIn: newMatrix);

                  // if (newOffset.dx < 0 || newOffset.dy < 0) {
                  //   dev.log('Kilóg');
                  // } else {
                  //   dev.log('Mozgatás');

                  // }
                  matrix.value = newMatrix;
                },
                shouldTranslate: selected.value && true,
                shouldScale: selected.value && false,
                shouldRotate: selected.value && false,
                focalPointAlignment: Alignment.center,
                clipChild: true,
                child: Transform(
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
                                  color: widget.controller.color,
                                  border: Border.all(
                                      color: (selected.value
                                          ? const Color.fromARGB(
                                              255, 16, 128, 219)
                                          : Colors.black),
                                      width: selected.value ? 3 : 0)),
                              child: Center(
                                child: widget.controller.icon,
                              ),
                            ),
                          ),
                        ),
                        if (selected.value)
                          ...sizers.map((e) => _sizerBuilder(e, angle.value)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _sizerBuilder(Sizer sizer, double angle) {
    var helperRect = sizer.alignment.inscribe(sizerSize, rect.value);

    Offset? offset;

    if (sizer.alignment == Alignment.topLeft) {
      offset = helperRect.topLeft;
    } else if (sizer.alignment == Alignment.topRight) {
      offset = helperRect.topLeft;
    } else if (sizer.alignment == Alignment.bottomLeft) {
      offset = helperRect.topLeft;
    } else if (sizer.alignment == Alignment.bottomRight) {
      offset = helperRect.topLeft;
    }

    var finalRect =
        _rotateSizer(offset ?? const Offset(0, 0), helperRect.size, angle);
    // .shift(sizer.mask * _size * -0.6);

    var centerRect = Alignment.center.inscribe(sizerSize, rect.value);

    var interpolated = Rect.lerp(finalRect, centerRect, 0);
    return Positioned.fromRect(
      rect: interpolated ?? Rect.zero,
      child: Transform.rotate(
        angle: angle,
        child: GestureDetector(
          onPanStart: (details) => _panStart(sizer, details),
          onPanUpdate: _panUpdate,
          onPanEnd: _panEnd,
          child: Container(
            decoration: ShapeDecoration(
              shape: const CircleBorder(),
              color: sizer.alignment == Alignment.topLeft
                  ? Colors.blue
                  : sizer.alignment == Alignment.topRight
                      ? Colors.red
                      : sizer.alignment == Alignment.bottomLeft
                          ? Colors.green
                          : sizer.alignment == Alignment.bottomRight
                              ? Colors.yellow
                              : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Rect _rotateSizer(Offset offset, Size size, double angle) {
    var relativeOffset = offset - rect.value.center;
    var rotatedRelativeOffset = Offset(
      (relativeOffset.dx * cos(angle)) - (relativeOffset.dy * sin(angle)),
      (relativeOffset.dx * sin(angle)) + (relativeOffset.dy * cos(angle)),
    );

    var rotatedOffset = rect.value.center + rotatedRelativeOffset;
    var finalRect = rotatedOffset & size;
    return finalRect;
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
