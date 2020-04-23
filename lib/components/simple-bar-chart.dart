import 'dart:math';

import 'package:areix/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Bar chart
class SimpleBarChart extends StatelessWidget {
  final List<ChartData> data;
  final double height;
  final double _maxValue;

  SimpleBarChart(
    this.data, {
    Key key,
    @required this.height,
  })  : assert(data != null && data.isNotEmpty),
        _maxValue = data.map((x) => x.value.abs()).reduce(max),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (height < 32) {
      return Container(height: height);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.map((item) => _chartItem(item, height - 36)).toList(),
    );
  }

  Widget _chartItem(ChartData item, double height) {
    final h = _maxValue == 0 ? 1.0 : height * item.value.abs() / _maxValue;

    final _normal = TextStyle(fontSize: 11, fontWeight: FontWeight.w400);
    final _small = TextStyle(fontSize: 9, fontWeight: FontWeight.w400);

    final fixed = currency(item.value, fixed: 2);
    final doubleVal = fixed.substring(fixed.length - 2);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(item.label, style: _normal),
        RichText(
          text: TextSpan(
            text: currency(item.value, fixed: 0),
            style: _normal,
            children: [TextSpan(text: '.$doubleVal', style: _small)],
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 24,
          height: max(h, 1),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.white, width: 2)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x8800FFD6), Color(0x0000FFD7)],
            ),
          ),
        ),
      ],
    );
  }
}

class ChartData {
  final String label;
  final double value;

  ChartData({
    @required this.label,
    @required this.value,
  });
}
