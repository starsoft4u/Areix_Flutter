import 'dart:ui';

import 'package:after_layout/after_layout.dart';
import 'package:areix/components/axis.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

enum RptFillMode {
  none,
  above,
  below,
}

enum RptLineMode {
  solid,
  dash,
}

// Line chart
class RptLineChart extends StatefulWidget {
  final List<RptLineChartData> data;
  final RptAxis axisX;
  final RptAxis axisY;
  final double paddingTop;
  final bool animate;

  RptLineChart(
    this.data, {
    Key key,
    @required this.axisX,
    @required this.axisY,
    this.paddingTop = 0,
    this.animate = true,
  })  : assert(data != null && data.isNotEmpty),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _RptLineChartState();
}

class _RptLineChartState extends State<RptLineChart>
    with AfterLayoutMixin<RptLineChart>, SingleTickerProviderStateMixin {
  double _axisXLabelHeight = 20;
  double _axisYLabelWidth = 20;

  final GlobalKey _keyAxisX = GlobalKey();
  final GlobalKey _keyAxisY = GlobalKey();
  final GlobalKey _keyAxisXLabels = GlobalKey();
  final GlobalKey _keyAxisYLabels = GlobalKey();

  double _panX = -1;

  AnimationController controller;
  Animation<double> animation;
  double _progress = 0;

  @override
  void initState() {
    super.initState();

    if (widget.animate) {
      controller = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
      final Animation curve = CurvedAnimation(parent: controller, curve: Curves.decelerate);
      animation = Tween<double>(begin: 0, end: 1).animate(curve);
      animation.addListener(() {
        setState(() {
          _progress = animation.value;
        });
      });

      controller.forward();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _axisYLabel(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _axisYLabels(),
              Expanded(
                child: Column(children: [
                  Expanded(child: _content()),
                  _axisXLabels(),
                ]),
              ),
              _axisXLabel(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _axisXLabel() {
    if (widget.axisX.title == null) {
      return Container(
        key: _keyAxisX,
        width: 0,
      );
    } else if (widget.axisX.labels.isEmpty) {
      return Container(
        key: _keyAxisX,
        margin: const EdgeInsets.only(left: 8),
        child: Text(widget.axisX.title, style: widget.axisX.titleTextStyle),
      );
    } else {
      return Container(
        key: _keyAxisX,
        margin: const EdgeInsets.only(left: 8),
        height: _axisXLabelHeight * 2,
        child: Center(child: Text(widget.axisX.title, style: widget.axisX.titleTextStyle)),
      );
    }
  }

  Widget _axisYLabel() {
    if (widget.axisY.title == null) {
      return Container(
        key: _keyAxisY,
        height: 0,
      );
    } else if (widget.axisY.labels.isEmpty) {
      return Container(
        key: _keyAxisY,
        margin: const EdgeInsets.only(bottom: 8),
        child: Text(widget.axisY.title, style: widget.axisY.titleTextStyle),
      );
    } else {
      return Container(
        key: _keyAxisY,
        margin: const EdgeInsets.only(bottom: 8),
        width: _axisYLabelWidth * 2,
        child: Center(child: Text(widget.axisY.title, style: widget.axisY.titleTextStyle)),
      );
    }
  }

  Widget _axisXLabels() {
    if (widget.axisX.labels.isNotEmpty) {
      return Container(
        key: _keyAxisXLabels,
        padding: EdgeInsets.only(top: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.axisX.labelsWidget,
        ),
      );
    } else if (widget.axisX.title == null) {
      return Container(
        key: _keyAxisXLabels,
        height: 0,
      );
    } else {
      return Container(
        key: _keyAxisXLabels,
        height: _axisXLabelHeight,
      );
    }
  }

  Widget _axisYLabels() {
    if (widget.axisY.labels.isNotEmpty) {
      return Container(
        key: _keyAxisYLabels,
        padding: EdgeInsets.only(right: 4, bottom: _axisXLabelHeight),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: widget.axisY.labelsWidget,
        ),
      );
    } else if (widget.axisY.title == null) {
      return Container(
        key: _keyAxisYLabels,
        width: 0,
      );
    } else {
      return Container(
        key: _keyAxisYLabels,
        width: _axisYLabelWidth,
      );
    }
  }

  Widget _content() {
    return ClipRect(
      child: Stack(children: [
        _chart(),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: widget.axisY.enabled ? widget.axisY.width : 0,
            height: double.infinity,
            color: widget.axisY.color,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: widget.axisX.enabled ? widget.axisX.width : 0,
            color: widget.axisY.color,
          ),
        ),
      ]),
    );
  }

  Widget _chart() {
    return GestureDetector(
      onPanStart: (DragStartDetails e) => setState(() {
        RenderBox box = context.findRenderObject();
        final local = box.globalToLocal(e.globalPosition);
        _panX = local.dx - _axisYLabelWidth;
      }),
      onPanUpdate: (e) => setState(() {
        RenderBox box = context.findRenderObject();
        final local = box.globalToLocal(e.globalPosition);
        _panX = local.dx - _axisYLabelWidth;
      }),
      onPanEnd: (e) => setState(() => _panX = -1),
      onPanCancel: () => setState(() => _panX = -1),
      child: CustomPaint(
        size: Size.infinite,
        painter: _RptLineChartPainter(
          widget.data,
          xMax: widget.axisX.max,
          yMax: widget.axisY.max,
          xLabels: widget.axisX.labels,
          paddingTop: widget.paddingTop,
          panX: _panX,
          progress: _progress,
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      if (widget.axisX.labels.isNotEmpty) {
        final RenderBox _box = _keyAxisXLabels.currentContext.findRenderObject();
        _axisXLabelHeight = _box.size.height;
      } else if (widget.axisX.title == null) {
        _axisXLabelHeight = 0;
      } else {
        final RenderBox _box = _keyAxisX.currentContext.findRenderObject();
        _axisXLabelHeight = _box.size.height / 2;
      }

      if (widget.axisY.labels.isNotEmpty) {
        final RenderBox _box = _keyAxisYLabels.currentContext.findRenderObject();
        _axisYLabelWidth = _box.size.width;
      } else if (widget.axisY.title == null) {
        _axisYLabelWidth = 0;
      } else {
        final RenderBox _box = _keyAxisY.currentContext.findRenderObject();
        _axisYLabelWidth = _box.size.width / 2;
      }
    });
  }
}

class _RptLineChartPainter extends CustomPainter {
  final List<RptLineChartData> data;
  final double xMax;
  final double yMax;
  final List<dynamic> xLabels;
  final double paddingTop;
  final double panX;
  final double progress;

  _RptLineChartPainter(
    this.data, {
    @required this.xMax,
    @required this.yMax,
    @required this.xLabels,
    @required this.paddingTop,
    @required this.panX,
    @required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // erase for anim
    canvas.clipRect(
      Rect.fromLTRB(0, 0, progress * size.width, size.height),
      clipOp: ClipOp.intersect,
    );

    final paint = Paint();

    final xStep = size.width / (xMax - 1);

    for (RptLineChartData chartData in data) {
      var path = Path();

      // draw line
      RptPointData start = chartData.data.first;
      path.moveTo(start.index * xStep, ((yMax - start.value) / yMax) * (size.height - paddingTop) + paddingTop);

      chartData.data.skip(1).forEach((item) {
        double x = item.index * xStep;
        double y = ((yMax - item.value) / yMax) * (size.height - paddingTop) + paddingTop;
        path.lineTo(x, y);
        // match to axisX values (debug)
        // canvas.drawLine(Offset(x, y), Offset(x, size.height), paint);
      });

      paint
        ..style = PaintingStyle.stroke
        ..color = chartData.lineColor
        ..strokeWidth = chartData.lineWidth;

      if (chartData.lineMode == RptLineMode.solid) {
        canvas.drawPath(path, paint);
      } else {
        canvas.drawPath(dashPath(path, dashArray: CircularIntervalList<double>([5, 5])), paint);
      }

      // draw fill
      if (chartData.fillMode != RptFillMode.none) {
        double startX = chartData.data.first.index * xStep;
        double lastX = chartData.data.last.index * xStep;
        if (chartData.fillMode == RptFillMode.below) {
          path
            ..lineTo(lastX, size.height)
            ..lineTo(startX, size.height)
            ..close();
        } else if (chartData.fillMode == RptFillMode.above) {
          path
            ..lineTo(lastX, 0)
            ..lineTo(startX, 0)
            ..close();
        }

        canvas.drawPath(
          path,
          paint
            ..style = PaintingStyle.fill
            ..color = chartData.fillColor,
        );
      }
    }

    // draw pan
    if (panX < 0) {
      return;
    }

    double maxY = 0;
    double labelOffset = 8;

    for (RptLineChartData chartData in data) {
      final index = panX / xStep;
      final min = chartData.data.lastWhere((item) => item.index <= index, orElse: () => null);
      final max = chartData.data.firstWhere((item) => item.index >= index, orElse: () => null);

      if (chartData.enablePanGesture && min != null && max != null) {
        var yVal = min.value;
        if (min != max) {
          final dy = max.value - min.value;
          final dx = (max.index - min.index) * xStep;
          final a = dy / dx;
          final x = panX - (min.index * xStep);
          yVal = a * x + min.value;
        }
        if (yVal > maxY) {
          maxY = yVal;
        }
        final point = Offset(panX, ((yMax - yVal) / yMax) * (size.height - paddingTop) + paddingTop);

        // draw point
        canvas.drawPoints(
          PointMode.points,
          [point],
          paint
            ..style = PaintingStyle.stroke
            ..color = Colors.white
            ..strokeWidth = 4
            ..strokeCap = StrokeCap.round,
        );

        // draw label
        TextSpan span = TextSpan(
          text: "${currency(yVal, fixed: 0)}",
          style: TextStyle(fontSize: 14, color: chartData.lineColor),
        );
        TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        );
        tp.layout();

        final rect = Rect.fromLTWH(labelOffset, 8, tp.width + 4, tp.height + 4);

        canvas.drawRect(
          rect,
          paint
            ..style = PaintingStyle.fill
            ..color = Colors.black.withOpacity(0.5),
        );
        tp.paint(canvas, Offset(rect.left + 2, rect.top + 2));

        labelOffset += (rect.width + 4);

        // var offsetX = 8;
        // var width = tp.width + 4;
        // var height = tp.height + 4;
        // var y = point.dy - height / 2;
        // if (y > size.height - height) {
        //   y = size.height - height;
        // }
        // Rect rect = Rect.zero;
        // if (size.width - panX < (width + 4)) {
        //   rect = Rect.fromLTWH(panX - width - offsetX, y, width, height);
        // } else {
        //   rect = Rect.fromLTWH(panX + offsetX, y, width, height);
        // }

        // canvas.drawRect(
        //   rect,
        //   paint
        //     ..style = PaintingStyle.fill
        //     ..color = Colors.black.withOpacity(0.5),
        // );
        // tp.paint(canvas, Offset(rect.left + 2, rect.top + 2));
      }
    }

    // draw line
    canvas.drawLine(
        Offset(panX, ((yMax - maxY) / yMax) * (size.height - paddingTop) + paddingTop),
        Offset(panX, size.height),
        paint
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);

    // draw axis label
    final index = (panX / xStep).round();
    var axis;
    if (xLabels.length == xMax) {
      axis = xLabels[index.toInt()];
    } else {
      axis = (index + 1).toString();
    }
    TextSpan span = TextSpan(text: axis, style: const TextStyle(fontSize: 14));
    TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp.layout();

    double offsetX = 8;
    double width = tp.width + 4;
    double height = tp.height + 4;
    Rect rect = Rect.zero;
    if (size.width - panX < (width + 4)) {
      rect = Rect.fromLTWH(panX - width - offsetX, size.height - height, width, height);
    } else {
      rect = Rect.fromLTWH(panX + offsetX, size.height - height, width, height);
    }

    canvas.drawRect(
      rect,
      paint
        ..style = PaintingStyle.fill
        ..color = Colors.black.withOpacity(0.5),
    );
    tp.paint(canvas, Offset(rect.left + 2, rect.top + 2));
  }

  @override
  bool shouldRepaint(_RptLineChartPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(_RptLineChartPainter oldDelegate) => true;
}

class RptLineChartData {
  final List<RptPointData> data;
  final RptLineMode lineMode;
  final double lineWidth;
  final Color lineColor;
  final RptFillMode fillMode;
  final Color fillColor;
  final bool enablePanGesture;

  RptLineChartData(
    this.data, {
    this.lineMode = RptLineMode.solid,
    this.lineWidth = 1,
    this.lineColor = primaryColor,
    this.fillMode = RptFillMode.none,
    this.fillColor = primaryColor,
    this.enablePanGesture = true,
  }) : assert(data != null && data.isNotEmpty) {
    data.sort((a, b) => a.index.compareTo(b.index));
  }
}

class RptPointData {
  final int index;
  final double value;

  RptPointData({@required this.index, @required this.value});
}
