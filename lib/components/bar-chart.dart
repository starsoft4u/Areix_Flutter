import 'package:after_layout/after_layout.dart';
import 'package:areix/components/axis.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

typedef void RptBarChartCallback(int index);

// Bar chart
class RptBarChart extends StatefulWidget {
  final List<RptBarChartData> data;
  final RptAxis axisX;
  final RptAxis axisY;
  final bool animate;
  final RptBarChartCallback onTap;

  RptBarChart(
    this.data, {
    Key key,
    @required this.axisX,
    @required this.axisY,
    this.animate = true,
    this.onTap,
  })  : assert(data != null && data.isNotEmpty),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _RptBarChartState();
}

class _RptBarChartState extends State<RptBarChart> with AfterLayoutMixin<RptBarChart>, SingleTickerProviderStateMixin {
  double _axisXLabelHeight = 20;
  double _axisYLabelWidth = 20;
  double _axisXStep = 100;
  Size _chartSize = Size.zero;

  GlobalKey _keyAxisX = GlobalKey();
  GlobalKey _keyAxisY = GlobalKey();
  GlobalKey _keyAxisXLabels = GlobalKey();
  GlobalKey _keyAxisYLabels = GlobalKey();
  GlobalKey _keyChart = GlobalKey();

  double _panX = -1;

  AnimationController _controller;
  double _progress = 1;

  @override
  void initState() {
    super.initState();

    if (widget.animate) {
      _controller = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
      final Animation curve = CurvedAnimation(parent: _controller, curve: Curves.decelerate);
      Animation<double> animation = Tween<double>(begin: 0, end: 1).animate(curve);
      animation.addListener(() {
        setState(() {
          _progress = animation.value;
        });
      });
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _axisY(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _axisYLabels(),
              Expanded(
                child: Column(children: [
                  Expanded(child: _chart()),
                  _axisXLabels(),
                ]),
              ),
              _axisX(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _axisX() {
    if (widget.axisX.title == null) {
      return Container(
        key: _keyAxisX,
        width: 0,
      );
    } else if (widget.axisX.labels.isEmpty) {
      return Container(
        key: _keyAxisX,
        child: Text(
          widget.axisX.title,
          style: widget.axisX.titleTextStyle,
        ),
      );
    } else {
      return Container(
        key: _keyAxisX,
        height: _axisXLabelHeight * 2,
        child: Center(
          child: Text(
            widget.axisX.title,
            style: widget.axisX.titleTextStyle,
          ),
        ),
      );
    }
  }

  Widget _axisY() {
    if (widget.axisY.title == null) {
      return Container(
        key: _keyAxisY,
        height: 0,
      );
    } else if (widget.axisY.labels.isEmpty) {
      return Container(
        key: _keyAxisY,
        margin: const EdgeInsets.only(bottom: 8),
        child: Text(
          widget.axisY.title,
          style: widget.axisY.titleTextStyle,
        ),
      );
    } else {
      return Container(
        key: _keyAxisY,
        margin: const EdgeInsets.only(bottom: 8),
        width: _axisYLabelWidth * 2,
        child: Center(
          child: Text(
            widget.axisY.title,
            style: widget.axisY.titleTextStyle,
          ),
        ),
      );
    }
  }

  Widget _axisXLabels() {
    if (widget.axisX.labels.isNotEmpty) {
      return Container(
        key: _keyAxisXLabels,
        padding: EdgeInsets.only(
          top: 4,
          left: _axisXStep / 2,
          right: _axisXStep / 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.axisX.labelsWidget
              .map((item) => Container(
                    width: _axisXStep * 3,
                    child: item,
                  ))
              .toList(),
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

  Widget _chart() {
    return ClipRect(
      child: Stack(children: [
        GestureDetector(
          onTapUp: (e) {
            RenderBox box = context.findRenderObject();
            final local = box.globalToLocal(e.globalPosition);
            box = _keyAxisY.currentContext.findRenderObject();
            Offset position = Offset(local.dx - _axisYLabelWidth, local.dy - box.size.height);
            handleTap(position);
          },
          onPanStart: (e) => setState(() {
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
            key: _keyChart,
            size: Size.infinite,
            painter: _RptBarChartPainter(
              widget.data,
              xMax: widget.axisX.max,
              yMax: widget.axisY.max,
              panX: _panX,
              progress: _progress,
            ),
          ),
        ),
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

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      if (widget.axisX.labels.isNotEmpty) {
        RenderBox _box = _keyAxisXLabels.currentContext.findRenderObject();
        _axisXLabelHeight = _box.size.height;
        _axisXStep = _box.size.width / (widget.axisX.max * 3 + 1);
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

      final RenderBox _box = _keyChart.currentContext.findRenderObject();
      _chartSize = _box.size;
    });
  }

  void handleTap(Offset position) {
    if (widget.onTap == null) {
      return;
    }

    final count = (3 * widget.axisX.max) + 1;
    final step = _chartSize.width / count;

    for (int i = 0; i < widget.data.length; i++) {
      RptBarChartData item = widget.data[i];

      // Draw rectangle
      double width = 2 * step;
      double height = (item.value / widget.axisY.max) * _chartSize.height;
      double x = (3 * i + 1) * step;
      double y = _chartSize.height - height;
      Rect rect = Rect.fromLTWH(x, y, width, height);

      if (rect.contains(position)) {
        widget.onTap(i);
        break;
      }
    }
  }
}

class _RptBarChartPainter extends CustomPainter {
  final List<RptBarChartData> data;
  final double xMax;
  final double yMax;
  final double panX;
  final double progress;

  _RptBarChartPainter(
    this.data, {
    @required this.xMax,
    @required this.yMax,
    @required this.panX,
    @required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final count = (3 * xMax) + 1;
    final step = size.width / count;

    Rect panRect = Rect.zero;
    int panIndex = -1;

    for (int i = 0; i < data.length; i++) {
      final item = data[i];

      // Draw rectangle
      double width = 2 * step;
      double height = (item.value / yMax) * size.height * progress;
      double x = (3 * i + 1) * step;
      double y = size.height - height;
      Rect rect = Rect.fromLTWH(x, y, width, height);
      canvas.drawRect(
        rect,
        paint
          ..color = item.color
          ..style = PaintingStyle.fill,
      );

      // Draw limit dash
      height = (item.limit / yMax) * size.height * progress;
      x -= (step * 0.25);
      y = size.height - height;
      width = step * 2.5;
      canvas.drawPath(
        dashPath(
            Path()
              ..moveTo(x, y)
              ..lineTo(x + width, y),
            dashArray: CircularIntervalList<double>([4, 2])),
        paint
          ..color = item.limitColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      if (panX >= rect.left && panX <= rect.right) {
        panRect = rect;
        panIndex = i;
      }
    }

    if (panIndex >= 0) {
      final item = data[panIndex];

      // draw pan
      TextSpan span = TextSpan(
        text: "${currency(item.value, fixed: 0)} / ",
        style: const TextStyle(fontSize: 12),
        children: [
          TextSpan(text: "${currency(item.limit, fixed: 0)}", style: TextStyle(color: item.limitColor, fontSize: 12)),
        ],
      );
      TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();

      double offsetX = 8;
      double width = tp.width + 4;
      double height = tp.height + 4;
      double x = panRect.center.dx - width / 2;
      double y = panRect.top - height - 4;

      Rect label = Rect.zero;
      if (x < offsetX) {
        x = offsetX;
      } else if (x + width > size.width - offsetX) {
        x = size.width - width - offsetX;
      }
      if (y < 0) {
        y = panRect.top + 4;
      }

      label = Rect.fromLTWH(x, y, width, height);
      canvas.drawRect(
        label,
        paint
          ..style = PaintingStyle.fill
          ..color = Colors.black.withOpacity(0.5),
      );
      tp.paint(canvas, Offset(label.left + 2, label.top + 2));
    }
  }

  @override
  bool shouldRepaint(_RptBarChartPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(_RptBarChartPainter oldDelegate) => true;
}

class RptBarChartData {
  final double value;
  final double limit;
  final Color color;
  final Color limitColor;

  RptBarChartData({
    @required this.value,
    @required this.limit,
    this.color = Colors.black,
    this.limitColor = Colors.green,
  });
}
