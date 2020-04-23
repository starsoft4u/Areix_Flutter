import 'dart:math';

import 'package:areix/components/custom-gesture.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef void RptPieChartCallback(int index);

// Pie chart
class RptPieChart extends StatefulWidget {
  final List<RptPieChartData> data;
  final RptPieContentData contentData;
  final double total;
  final double radius;
  final double width;
  final double labelSpace;
  final double labelSize;
  final bool isPercent;
  final bool fillRemaining;
  final bool animate;
  final bool rotate;
  final RptPieChartCallback onTap;

  RptPieChart(
    this.data, {
    Key key,
    @required this.contentData,
    double total,
    this.radius = 100,
    this.width = 6,
    this.labelSpace = 48,
    this.labelSize = 72,
    this.isPercent = true,
    this.fillRemaining = false,
    this.animate = true,
    this.rotate = true,
    this.onTap,
  })  : assert(data != null && data.isNotEmpty),
        total = total ?? data.map((item) => item.value).reduce((a, b) => a + b),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _RptPieChartState();
}

class _RptPieChartState extends State<RptPieChart> with SingleTickerProviderStateMixin {
  Size _size = Size.zero;

  Offset _panOffset;
  int _selectedIndex = -1;
  double _rotateDegree;
  double _startDegree = -pi / 2;

  AnimationController controller;
  Animation<double> animation;
  double _progress = 1;

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
    return LayoutBuilder(builder: (context, constraint) {
      _size = Size(constraint.maxWidth, constraint.maxHeight);
      return Stack(children: [_chart(), _content()]..addAll(_labels()));
    });
  }

  Widget _content() {
    CrossAxisAlignment alignment = CrossAxisAlignment.center;
    if (widget.contentData.alignment.x > 0) {
      alignment = CrossAxisAlignment.start;
    } else if (widget.contentData.alignment.x < 0) {
      alignment = CrossAxisAlignment.end;
    }

    final spent = _selectedIndex >= 0 ? widget.data[_selectedIndex].value : widget.contentData.spent;
    final total = widget.contentData.total;
    final percent = total == 0 ? 0 : min(spent * 100 ~/ total, 100);

    final child = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: alignment,
      children: [
        Text('$percent%', style: widget.contentData.headStyle),
        SizedBox(height: 4),
        Text('Spent :', style: widget.contentData.bodyStyle),
        Text(
          '${currency(spent, optimized: spent >= 100000 || total >= 100000)} / ${currency(total, optimized: spent >= 100000 || total >= 100000)}',
          style: widget.contentData.bodyStyle,
        ),
      ],
    );

    return widget.contentData.alignment.x == 0
        ? Align(
            alignment: widget.contentData.alignment,
            child: Container(
              width: widget.radius * 2,
              child: child,
            ),
          )
        : Positioned(
            left: widget.contentData.alignment.x > 0 ? _size.width / 2 + 8 : null,
            right: widget.contentData.alignment.x < 0 ? _size.width / 2 + 8 : null,
            child: Container(
              width: widget.radius - 12,
              height: _size.height,
              child: child,
            ),
          );
  }

  List<Widget> _labels() {
    final center = _size.center(Offset.zero);

    List<Widget> labels = [];
    double current = _startDegree;

    for (var i = 0; i < widget.data.length; i++) {
      final item = widget.data[i];
      final percent = item.value / widget.total;
      final angle = 2 * pi * percent;

      double radius = widget.radius + widget.labelSpace;
      if (i == _selectedIndex) {
        radius = widget.radius - widget.labelSpace;
      }

      final x = cos(current + angle / 2) * radius;
      final y = sin(current + angle / 2) * radius;

      Alignment align;
      if (x.abs() > y.abs()) {
        if (i == _selectedIndex) {
          align = x >= 0 ? Alignment.centerLeft : Alignment.centerRight;
        } else {
          align = x >= 0 ? Alignment.centerRight : Alignment.centerLeft;
        }
      } else {
        if (i == _selectedIndex) {
          align = y >= 0 ? Alignment.topCenter : Alignment.bottomCenter;
        } else {
          align = y >= 0 ? Alignment.bottomCenter : Alignment.topCenter;
        }
      }

      final title = widget.isPercent
          ? '${(item.value * 100.0 / widget.contentData.total).toStringAsFixed(2)}%'
          : currency(item.value);

      final _label = item.generateWidget(align, widget.labelSize, title);
      if (_label != null) {
        labels.add(
          Positioned(
            left: center.dx + x - (widget.labelSize / 2),
            top: center.dy + y - (widget.labelSize / 2),
            child: _label,
          ),
        );
      }

      current = formatDegree(current + angle);
    }

    return labels;
  }

  Widget _chart() {
    final spent = _selectedIndex >= 0 ? widget.data[_selectedIndex].value : widget.contentData.spent;
    final total = widget.contentData.total;
    final percent = total == 0 ? 0 : spent ~/ total;

    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        CustomGestureRecognizer: GestureRecognizerFactoryWithHandlers<CustomGestureRecognizer>(
          () => CustomGestureRecognizer(
            onPanStart: _handlePanStart,
            onPanUpdate: _handlePanUpdate,
            onPanEnd: _handlePanEnd,
            onTap: _handleTap,
          ),
          (CustomGestureRecognizer instance) {},
        )
      },
      child: CustomPaint(
        size: Size.infinite,
        painter: _RptPieChartPainter(
          widget.data,
          total: widget.total,
          radius: widget.radius,
          width: widget.width,
          labelSpace: widget.labelSpace,
          fillPercent: percent,
          fillRemaining: widget.fillRemaining,
          rotate: widget.rotate,
          startDegree: _startDegree,
          selectedIndex: _selectedIndex,
          progress: _progress,
        ),
      ),
    );
  }

  void _handleTap(Offset offset) {
    if (widget.onTap == null) {
      return;
    }

    final index = _indexFromOffset(offset);
    if (index >= 0) {
      widget.onTap(index);
    }
  }

  void _handlePanStart(Offset offset) {
    setState(() {
      _panOffset = _localOffset(offset);
      if (widget.rotate) {
        _rotateDegree = _angle(_panOffset);
      } else {
        _selectedIndex = _indexFromOffset(_panOffset);
      }
    });
  }

  void _handlePanUpdate(Offset offset) {
    setState(() {
      _panOffset = _localOffset(offset);
      if (widget.rotate) {
        double _degree = _angle(_panOffset);
        _startDegree = formatDegree(_startDegree + _degree - _rotateDegree);
        _rotateDegree = _degree;
      } else {
        _selectedIndex = _indexFromOffset(_panOffset);
      }
    });
  }

  void _handlePanEnd(Offset offset) {
    setState(() {
      _selectedIndex = -1;
      _panOffset = null;
    });
  }

  Offset _localOffset(Offset offset) {
    RenderBox box = context.findRenderObject();
    return box.globalToLocal(offset);
  }

  double _angle(Offset offset) {
    Offset center = _size.center(Offset.zero);
    double angle = Offset(offset.dx - center.dx, offset.dy - center.dy).direction;
    return formatDegree(angle);
  }

  int _indexFromOffset(Offset offset) {
    if (offset == null || widget.rotate) {
      return -1;
    }

    final center = _size.center(Offset.zero);
    double current = _startDegree;

    for (var i = 0; i < widget.data.length; i++) {
      final percent = (widget.data[i]).value / widget.total;
      final angle = 2 * pi * percent;
      double degree = Offset(offset.dx - center.dx, offset.dy - center.dy).direction;
      double max = formatDegree(current + angle);
      if (compareDegree(degree, current, max)) {
        return i;
      }
      current = formatDegree(current + angle);
    }

    return -1;
  }
}

class _RptPieChartPainter extends CustomPainter {
  final List<RptPieChartData> data;
  final double total;
  final double radius;
  final double width;
  final double labelSpace;
  final int fillPercent;
  final bool fillRemaining;
  final bool rotate;
  final double startDegree;
  final int selectedIndex;
  final double progress;

  _RptPieChartPainter(
    this.data, {
    @required this.total,
    @required this.radius,
    @required this.width,
    @required this.labelSpace,
    @required this.fillPercent,
    @required this.fillRemaining,
    @required this.rotate,
    @required this.startDegree,
    @required this.selectedIndex,
    @required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final center = size.center(Offset.zero);

    // draw content fill
    final _radius = radius - (width / 2);
    Rect rect = Rect.fromCircle(center: center, radius: _radius);
    final y = -((2 * _radius) * (fillPercent * progress / 100) - _radius);
    final start = asin(y / _radius);
    final end = pi - (start * 2);
    canvas.drawPath(
      Path()
        ..addArc(rect, start, end)
        ..close(),
      paint
        ..style = PaintingStyle.fill
        ..shader = LinearGradient(
          colors: const [darkColor, lightColor],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ).createShader(rect),
    );

    // Draw pie
    rect = Rect.fromCircle(center: center, radius: radius);
    final twoPi = 2 * pi;
    final spaceAngle = twoPi / 360;
    double current = startDegree;
    double processed = 0;

    paint
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..shader = null;

    data.asMap().forEach((index, item) {
      final percent = item.value / total;
      final angle = twoPi * percent;

      // draw pan
      paint.strokeWidth = selectedIndex == index ? width * 2 : width;

      // draw pie
      canvas.drawArc(
        rect,
        current,
        angle * progress - spaceAngle,
        false,
        paint..color = item.color,
      );

      current = formatDegree(current + angle);
      processed += item.value;
    });

    // draw remaining
    final remaining = total - processed;
    if (fillRemaining && remaining > 0) {
      final percent = remaining / total;
      final angle = twoPi * percent;

      canvas.drawArc(
        rect,
        current,
        angle * progress - spaceAngle,
        false,
        paint..color = primaryColor,
      );
    }
  }

  @override
  bool shouldRepaint(_RptPieChartPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(_RptPieChartPainter oldDelegate) => true;
}

class RptPieContentData {
  final double spent;
  final double total;
  final Alignment alignment;
  final TextStyle headStyle;
  final TextStyle bodyStyle;

  RptPieContentData({
    this.spent,
    this.total,
    this.alignment = Alignment.center,
    this.headStyle = const TextStyle(color: primaryColor, fontSize: 36, fontWeight: FontWeight.w500),
    this.bodyStyle = const TextStyle(color: primaryColor, fontSize: 15),
  });
}

class RptPieChartData {
  final double value;
  final Widget icon;
  final Color color;
  final Color textColor;
  final double textSize;
  final bool showLabel;

  RptPieChartData({
    @required this.value,
    this.icon,
    @required this.color,
    Color textColor,
    this.textSize = 10,
    this.showLabel = true,
  }) : this.textColor = textColor ?? color;

  Widget generateWidget(Alignment align, double size, String title) {
    final _labelTextStyle = TextStyle(color: textColor, fontSize: textSize);

    if (showLabel) {
      Widget label;
      final children = [
        icon == null ? Container() : Container(width: 24, height: 24, child: icon),
        SizedBox(width: 4, height: 4),
        Text(title, style: _labelTextStyle),
      ];
      if (align == Alignment.topCenter) {
        label = Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children.reversed.toList(),
        );
      } else if (align == Alignment.bottomCenter) {
        label = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        );
      } else if (align == Alignment.centerLeft) {
        label = Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children.reversed.toList(),
        );
      } else if (align == Alignment.centerRight) {
        label = Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        );
      }

      return IgnorePointer(
        child: Container(
          width: size,
          height: size,
          child: label,
        ),
      );
    } else {
      return null;
    }
  }
}

double formatDegree(double degree) {
  if (degree < -pi) {
    return degree + 2 * pi;
  } else if (degree > pi) {
    return degree - 2 * pi;
  } else {
    return degree;
  }
}

bool compareDegree(double degree, double min, double max) {
  double degree1 = formatDegree(degree);
  double min1 = formatDegree(min);
  double max1 = formatDegree(max);

  if (min1 >= max1) {
    return (degree1 >= (min1 - 2 * pi) && degree1 < max1) || (degree1 >= min1 && degree1 < (max1 + 2 * pi));
  } else {
    return degree1 >= min1 && degree1 < max1;
  }
}
